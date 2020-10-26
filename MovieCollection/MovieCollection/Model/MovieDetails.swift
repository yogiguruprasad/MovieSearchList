//
//  MovieDetails.swift
//  MovieCollection
//
//  Created by uday on 26/10/20.
//

import Foundation

struct MovieDetails:Codable {
    var status:String?
    var tagline: String?
    var title: String?
    var video: Bool
    var vote_average:Double?
    var vote_count: Int?
    var release_date: String
    var revenue:Int?
    var runtime:Int?
    var homepage: String
    var id: Int?
    var imdb_id: String
    var original_language: String
    var original_title: String
    var overview: String
    var popularity:Double?
    var poster_path: String
    var adult: Bool
    var backdrop_path: String?
    var belongs_to_collection: String?
    var budget: Int?
}
