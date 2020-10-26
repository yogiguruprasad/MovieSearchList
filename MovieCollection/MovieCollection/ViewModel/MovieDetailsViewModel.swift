//
//  MovieDetailsViewModel.swift
//  MovieCollection
//
//  Created by uday on 26/10/20.
//

import Foundation

class MovieDetailsViewModel{
    func getMovieDetails(movieId:String,callback:Callback<MovieDetails,String>){
        HttpClientApi.instance().makeAPICall(url: "movie/" + movieId, modelObject: MovieDetails.self, params: ["api_key":kAPI_Key], method: .get, callback: Callback(onSuccess: { (result) in
            print(result)
            callback.onSuccess(result)
        }, onFailure: { (error) in
            print(error)
            callback.onFailure(error)
        }))
    }
}
