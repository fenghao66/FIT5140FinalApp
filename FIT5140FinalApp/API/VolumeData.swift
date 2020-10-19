//
//  VolumeData.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 20/10/20.
//

import Foundation

class VolumeData: NSObject, Decodable {
    
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [MovieData]?
    

    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
