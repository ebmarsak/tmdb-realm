//
//  MovieDetailVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 10.05.2022.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    var movieID: Int
    var name: String
    var movie: Result
    
    init(movie: Result, movieID: Int, name: String) {
        self.movieID = movieID
        self.name = name
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print(movie.id)
        print(movie.name)
        print(movie.posterPath)
        print(movie.popularity)
    }
}
