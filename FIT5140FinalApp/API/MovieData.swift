//
//  MovieData.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 20/10/20.
//

import Foundation
class MovieData: NSObject, Decodable {
    var id: Int
    var title: String?
    var posterPath: String?
    var overview: String?
    var releaseDate: String?

    private enum RootKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }

    required init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: RootKeys.self)

        id = try movieContainer.decode(Int.self, forKey: .id)
        title = try movieContainer.decode(String.self, forKey: .title)
        overview = try? movieContainer.decode(String.self, forKey: .overview)
        releaseDate = try? movieContainer.decode(String.self, forKey: .releaseDate)
        posterPath = try? movieContainer.decode(String.self, forKey: .posterPath)
    }
}
