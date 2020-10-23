//
//  MovieDetailNew.swift
//  FIT5140FinalApp
//
//  Created by chengguang li  on 2020/10/23.
//

import UIKit

class MovieDetailNew: NSObject,Decodable {

   var id: Int?
   var title: String?
   var release_date:String?
   var backdrop_path:String?
   var runtime: Int?
   var voteCount: Int?
   var voteAvg: Double?
   var overView: String?
    var videos:[videos]?
    
    private enum CodingKeys:String,CodingKey{
       case id
       case title = "title"
       case release_date = "release_date"
       case runtime = "runtime"
       case overView = "overview"
       case voteCount = "vote_count"
       case voteAvg = "vote_average"
       case backdrop_path = "backdrop_path"
       case videos = "videos"
    }
    
    required init(from decoder: Decoder) throws{
        let movieContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try? movieContainer.decode(Int.self, forKey: .id)
        title = try? movieContainer.decode(String.self, forKey: .title)
        release_date = try? movieContainer.decode(String.self, forKey: .release_date)
        
        runtime = try? movieContainer.decode(Int.self, forKey: .runtime)
        voteCount = try? movieContainer.decode(Int.self, forKey: .voteCount)
        voteAvg = try? movieContainer.decode(Double.self, forKey: .voteAvg)
        overView = try? movieContainer.decode(String.self, forKey: .overView)
        backdrop_path = try? movieContainer.decode(String.self, forKey: .backdrop_path)
    }
    
     
}
