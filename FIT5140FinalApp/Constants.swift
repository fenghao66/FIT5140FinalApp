//
//  Constants.swift
//  FIT5140FinalApp
//
//  Created by Qfh on 23/10/20.
//

import Foundation

struct Constants {
    static let apiKey = "693f8973135b3d30c467e5377ed18164"
    static let REQUEST_STRING = "https://api.themoviedb.org/3"
    static var movieId = 1726
    
    static let MOVIE_SEARCH_BASE_URL = "https://api.themoviedb.org/3/search/movie"
    static let IMAGES_BASE_URL = "https://image.tmdb.org/t/p/"
    static let BACK_DROP_BASE_URL = IMAGES_BASE_URL + "w500"
    static let POSTER_BASE_URL = IMAGES_BASE_URL + "w185"
    static let KEY_POPULAR = "popular"
    static let KEY_UPCOMING = "upcoming"
    static let KEY_TOP_RATED = "top_rated"
    static let KEY_NOW_PLAYING = "now_playing"
}
