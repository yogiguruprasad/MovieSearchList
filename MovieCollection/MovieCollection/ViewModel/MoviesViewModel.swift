//
//  MoviesViewModel.swift
//  MovieCollection
//
//  Created by uday on 26/10/20.
//

import Foundation

class MoviesViewModel {
    var movieList = [Movies]()
    var totalPages = Int()
    func getMoviesList(pagenumber:Int,callback:Callback<MovieResult,String>){
        HttpClientApi.instance().makeAPICall(url: ConfigureURL.NOWPLAYING, modelObject: MovieResult.self, params: ["api_key":kAPI_Key,"page":"\(pagenumber)"], method: .post, callback: Callback(onSuccess: { (result) in
            self.movieList += result.results!
            self.totalPages = result.total_pages!
            callback.onSuccess(result)
        }, onFailure: { (error) in
            callback.onFailure(error)
        }))
    }
}
