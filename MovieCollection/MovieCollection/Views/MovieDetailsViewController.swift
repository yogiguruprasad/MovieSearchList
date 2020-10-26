//
//  MovieDetailsViewController.swift
//  MovieCollection
//
//  Created by uday on 26/10/20.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var moviePoster:UIImageView!
    @IBOutlet weak var movieOverview:UILabel!
    @IBOutlet weak var moviereleaseStatus:UILabel!
    @IBOutlet weak var movieReleaseDate:UILabel!
    @IBOutlet weak var movieVoting:UILabel!
    var movie:Movies?
    var viewModel = MovieDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        viewModel.getMovieDetails(movieId: movie!.id!.description, callback: Callback(onSuccess: { (result) in
            DispatchQueue.main.async {
                self.moviePoster.downloaded(from: BaseImageURL + (result.poster_path))
                self.movieOverview.text = result.overview
                self.movieReleaseDate.text = "Release Date: " + (result.release_date)
                self.movieVoting.text = "Votes: " + (result.vote_count?.description ?? "")
                self.moviereleaseStatus.text = "Release Status: " + (result.status ?? "")
            }
        }, onFailure: { (error) in
            
        }))
        
    }


}
