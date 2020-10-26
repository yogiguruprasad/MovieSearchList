//
//  ViewController.swift
//  MovieCollection
//
//  Created by Guru on 26/10/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moviesCollection:UICollectionView!
    var viewModel = MoviesViewModel()
    var pageNumber = 1
    let searchController = UISearchController(searchResultsController: nil)
    var searchlist = MovieResult()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
        
        let flow = UICollectionViewFlowLayout()
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flow.scrollDirection = .vertical
        moviesCollection.collectionViewLayout = flow
        self.getMoviesList(pagenumber: pageNumber)
    }
    func getMoviesList(pagenumber:Int){
        viewModel.getMoviesList(pagenumber: pagenumber,callback: Callback(onSuccess: { (result) in
            print(result)
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
            }
        }, onFailure: { (error) in
            print(error)
        }))
    }
    func search(searchName:String,pagenumber:Int){
        HttpClientApi.instance().makeAPICall(url: ConfigureURL.SEARCH, modelObject: MovieResult.self, params: ["api_key":kAPI_Key,"query":searchName,"page":"\(pagenumber)"], method: .get, callback: Callback(onSuccess: { (result) in
            print(result)
            DispatchQueue.main.async {
                self.moviesCollection.reloadData()
                self.isSearch = false
            }
        }, onFailure: { (error) in
            print(error)
        }))
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearch {
            return searchlist.results?.count ?? 0
        }
        return viewModel.movieList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCollectionCell", for: indexPath) as! MoviesCollectionViewCell
        if isSearch {
            cell.moviePoster.downloaded(from: BaseImageURL + (searchlist.results?[indexPath.row].poster_path ?? ""))
            cell.movieName.text = searchlist.results?[indexPath.row].title
            if searchlist.total_pages != pageNumber &&  searchlist.results!.count - 1 == indexPath.row {
                pageNumber += 1
                self.search(searchName: searchController.searchBar.text!, pagenumber: pageNumber)
            }
        }else{
            cell.moviePoster.downloaded(from: BaseImageURL + (viewModel.movieList[indexPath.row].poster_path ?? ""))
            cell.movieName.text = viewModel.movieList[indexPath.row].title
            if viewModel.totalPages != pageNumber &&  viewModel.movieList.count - 1 == indexPath.row {
                pageNumber += 1
                self.getMoviesList(pagenumber: pageNumber)
            }
        }
        cell.addShadow()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-20, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "MovieDetailsViewController") as! MovieDetailsViewController
        if isSearch {
            vc.movie = searchlist.results?[indexPath.row]
            vc.title = searchlist.results?[indexPath.row].title
        }else{
            vc.movie = viewModel.movieList[indexPath.row]
            vc.title = viewModel.movieList[indexPath.row].title
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {

    func updateSearchResults(for searchController: UISearchController) {
//        print("Searching with: " + (searchController.searchBar.text ?? ""))
//        let searchText = (searchController.searchBar.text ?? "")
//        search(searchName: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //isSearch = false
        pageNumber = 1
        moviesCollection.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearch = true
        print("Searching with: " + (searchController.searchBar.text ?? ""))
        let searchText = (searchController.searchBar.text ?? "")
        search(searchName: searchText,pagenumber: pageNumber)
    }
}
