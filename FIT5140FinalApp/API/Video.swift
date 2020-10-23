//
//  Video.swift
//  FIT5140FinalApp
//
//  Created by chengguang li  on 2020/10/24.
//

import UIKit

struct videos: Decodable {
    var  results: [result]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}


struct result: Decodable{
    var key:String?
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
    }
}
