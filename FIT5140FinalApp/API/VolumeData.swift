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
    
    var releaseDate: String?
    var backdropPath: String?
    var title: String?
    var overView: String?
    var voteCount: Int?
    var voteAvg: Double?
    var runtime: Int?
    var genres: [MovieGenre]?
    var  id: Int?

    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
        
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case title
        case overView = "overview"
        case voteCount = "vote_count"
        case voteAvg = "vote_average"
        case runtime
        case genres
        case id = "id"
    }
}
