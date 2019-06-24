//
//  DogAPI.swift
//  imgReq
//
//  Created by Hoshiar Sher on 6/21/19.
//  Copyright © 2019 Hoshiar Sher. All rights reserved.
//

import Foundation
import UIKit

class DogAPI{
    
    enum Endpoint {
        case randomImageFromAllDogs
        case randomImageForBreed (String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String{
            switch self {
            case .randomImageFromAllDogs:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
           
            }
        }
    }
    
    class func requestBreedList(completionHandler: @escaping ([String], Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoint.listAllBreeds.url){(data, resonse, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil) 
        }
        task.resume()
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?
        ) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(
            data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
            })
        task.resume()
    }
    
    class func requestRandomImg(comletionHadler: @escaping (DogImage?, Error?) -> Void){
        
        let randomImg = DogAPI.Endpoint.randomImageFromAllDogs.url
        
        let task = URLSession.shared.dataTask(with: randomImg, completionHandler: {(data, response, error) in
            
            guard let data = data else {
                comletionHadler(nil, error)
                return }
            
            let decoder = JSONDecoder()
            let imgData = try! decoder.decode(DogImage.self, from: data)
            
            comletionHadler(imgData, nil)
            print(imgData)
            
//            guard let dogImgUrl = URL(string: imgData.message) else {
//                 comletionHadler(nil, error)
//                return}
            
//            comletionHadler(dogImgUrl, error)
        })
            task.resume()
        }
        
    
    
    
}
