//
//  MovieDetailVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 10.05.2022.
//

import UIKit
import RealmSwift
//import AVFoundation

protocol MovieDetailDelegate : AnyObject {
    func didAddNewItem()
}

class MovieDetailVC: UIViewController {
    weak var delegate: MovieDetailDelegate?
    private let movieDetailViewModel = MovieDetailViewModel()
    let movieDetailView = MovieDetailView()
    
    let realm = try! Realm()
        
    init(movie: MovieInfo) {
        movieDetailViewModel.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = movieDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        movieDetailViewModel.delegate = self
        movieDetailView.delegate = self
        setViewProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sizeOfSV = self.movieDetailView.titleName.bounds.height + self.movieDetailView.overview.bounds.height + self.movieDetailView.addToFavoritesButton.bounds.height
        
        movieDetailView.scrollView.contentSize.height = sizeOfSV + 80
        print("\(sizeOfSV)")
    }
    
    // Set properties
    func setViewProperties() {
        movieDetailView.titleName.text = movieDetailViewModel.movie.title
        movieDetailView.overview.text = movieDetailViewModel.movie.overview
        movieDetailView.voteAverage.text = "Score: \(String(movieDetailViewModel.movie.voteAverage!))"
        movieDetailView.releaseDate.text = "Release Date: \(movieDetailViewModel.movie.releaseDate!)"
        // get backdrop image
        movieDetailViewModel.getBackdropFromURL(backdropPath: movieDetailViewModel.movie.backdropPath!, backdropView: movieDetailView.backdropImage)
    }
}

extension MovieDetailVC: MovieDetailDelegate {
    func didAddNewItem() { }
}

extension MovieDetailVC: MovieDetailViewDelegate {
    func didTapFavoriteButton() {
        movieDetailViewModel.didTapAddToFavorites()
    }
}
