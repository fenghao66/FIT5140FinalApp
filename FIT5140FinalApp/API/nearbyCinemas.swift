//
//  nearbyCinemas.swift
//  FIT5140FinalApp
//
//  Created by chengguang li on 2020/10/25.
//

import Foundation
// MARK: - nearByCinema

struct nearByCinema: Codable {
    var results: [Result]?
    var status: String?
}

// MARK: - Result
struct Result: Codable {
    var businessStatus: String?
    var geometry: Geometry?
    var name: String?
    var permanentlyClosed: Bool?
    var rating: Double?
    var types: [String]?
    var userRatingsTotal: Int?
    var vicinity: String?

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry = "geometry"
        case name
        case permanentlyClosed = "permanently_closed"
        case rating
        case types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    var location: Location?
    var viewport: Viewport?
}

// MARK: - Location
struct Location: Codable {
    var lat, lng: Double?
}

// MARK: - Viewport
struct Viewport: Codable {
    var northeast, southwest: Location?
}
