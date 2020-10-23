//
//  TrailorData.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 24/10/20.
//

import Foundation

class TrailorData: NSObject, Decodable {

    var trailorPath: String?

    private enum RootKeys: String, CodingKey {

        case trailorPath = "key"
    }

    required init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: RootKeys.self)

        trailorPath = try? movieContainer.decode(String.self, forKey: .trailorPath)
    }
}
