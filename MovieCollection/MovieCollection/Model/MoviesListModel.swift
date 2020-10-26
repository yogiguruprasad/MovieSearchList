//
//  MoviesListModel.swift
//  MovieCollection
//
//  Created by Guru on 26/10/20.
//

import Foundation

struct MovieResult:Codable {
    var page:Int?
    var total_results:Int?
    var total_pages:Int?
    var results:[Movies]?
}
struct Movies:Codable {
    var popularity:Double?
    var vote_count: Int?
    var video: Bool?
    var poster_path: String?
    var id: Int?
    var adult: Bool?
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var title: String?
    var vote_average: Double?
    var overview: String?
    var release_date: String?
}
