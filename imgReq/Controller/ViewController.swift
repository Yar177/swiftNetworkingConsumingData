//
//  ViewController.swift
//  imgReq
//
//  Created by Hoshiar Sher on 6/21/19.
//  Copyright © 2019 Hoshiar Sher. All rights reserved.
//

import UIKit

enum KittenImageLocation: String {
    case http = "http://www.kittenswhiskers.com/wp-content/uploads/sites/23/2014/02/Kitten-playing-with-yarn.jpg"
    case https = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Kitten_in_Rizal_Park%2C_Manila.jpg/460px-Kitten_in_Rizal_Park%2C_Manila.jpg"
    case error = "not a url"
}


class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imgLocation = KittenImageLocation.http.rawValue
  
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    
    func handleBreedsResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogAPI.requestBreedList(completionHandler: handleBreedsResponse(breeds:error:))
      
        
    }

    @IBAction func loadImg(_ sender: Any) {
        
        guard let imgUrl = URL(string: imgLocation) else{
            print("Cannot create URL")
            return
        }
        
//        let task = URLSession.shared.dataTask(with: imgUrl){
//            (data, response, error) in
//            guard let data = data else {
//                print("No data was returned ")
//                return
//            }
//
//            let donwloadedImg = UIImage(data: data)
//
//            DispatchQueue.main.async {
//                self.imageView.image = donwloadedImg
//            }
//
//        }
//        task.resume()
        
        
        let task = URLSession.shared.downloadTask(with: imgUrl){(location, response, error) in
            guard let location = location else {
                print("location is nil")
                return
            }
            print(location)
            let imgData = try! Data(contentsOf: location)
            let img = UIImage(data: imgData)
            
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }
        task.resume()
    }
    
    func handleImageFileResponse(image: UIImage?, error: Error?)  {
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
        
        
    }
    

    
}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let breed = breeds[row]

        let randomImg = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomImg){ (data, response, error) in
            
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            let imgData = try! decoder.decode(DogImage.self, from: data)
            
            print(imgData )
            
            guard let dogImgUrl = URL(string: imgData.message) else {return}
            
            DogAPI.requestImageFile(url: dogImgUrl, completionHandler: { (image, error) in
                self.handleImageFileResponse(image: image, error: error)
            })
            
        }
        
        task.resume()
    }
    
    
}

