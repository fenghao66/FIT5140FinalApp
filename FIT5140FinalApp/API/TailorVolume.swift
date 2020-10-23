//
//  TailorVolume.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 24/10/20.
//

import Foundation

class TrailorVolume: NSObject, Decodable {
    
    var id: Int?
    var results: [TrailorData]?

    private enum CodingKeys: String, CodingKey {
        case id
        case results
    }
}
