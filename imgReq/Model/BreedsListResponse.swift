//
//  BreedsListResponse.swift
//  imgReq
//
//  Created by Hoshiar Sher on 6/24/19.
//  Copyright © 2019 Hoshiar Sher. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable{
    let status: String
    let message: [String : [String] ]
}
