//
//  MovieDetailView.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation
import UIKit

class MovieDetailView: UIView {
    
    var backdropImage = UIImageView()
    var titleName = UILabel()
    var releaseDate = UILabel()
    var overview = UILabel()
    var voteAverage = UILabel()
    let addToFavoritesButton = UIButton()
//    let video = AVPlayer
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .systemBackground
//        setProperties()
//        configLayout()
    }
//
//    func setProperties() {
//        titleName.text = movieDetailViewModel.movie.title
//        overview.text = movieDetailViewModel.movie.overview
//        voteAverage.text = "Score: \(String(movieDetailViewModel.movie.voteAverage!))"
//        releaseDate.text = "Release Date: \(movieDetailViewModel.movie.releaseDate!)"
//    }
}
