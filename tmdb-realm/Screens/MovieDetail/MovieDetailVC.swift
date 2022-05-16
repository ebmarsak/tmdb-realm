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
    var movieDetailView = MovieDetailView()
    
    let realm = try! Realm()

    var backdropImage = UIImageView()
    var titleName = UILabel()
    var releaseDate = UILabel()
    var overview = UILabel()
    var voteAverage = UILabel()
    let addToFavoritesButton = UIButton()
//    let video = AVPlayer
    let scrollView = UIScrollView()
    let stackView = UIStackView()
        
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
        
        movieDetailViewModel.getBackdropFromURL(backdropPath: movieDetailViewModel.movie.backdropPath!, backdropView: backdropImage)
        
//        setProperties()
//        configLayout()
    }
    
    // Set properties
    func setProperties() {
        titleName.text = movieDetailViewModel.movie.title
        overview.text = movieDetailViewModel.movie.overview
        voteAverage.text = "Score: \(String(movieDetailViewModel.movie.voteAverage!))"
        releaseDate.text = "Release Date: \(movieDetailViewModel.movie.releaseDate!)"
    }
    
    // Config Layout
    func configLayout() {
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(backdropImage)
        stackView.addArrangedSubview(scrollView)
        scrollView.addSubview(titleName)
        scrollView.addSubview(overview)
        scrollView.addSubview(releaseDate)
        scrollView.addSubview(voteAverage)
        scrollView.addSubview(addToFavoritesButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        titleName.translatesAutoresizingMaskIntoConstraints = false
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        voteAverage.translatesAutoresizingMaskIntoConstraints = false
        overview.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backdropImage.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor),
            backdropImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backdropImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backdropImage.heightAnchor.constraint(equalToConstant: stackView.bounds.width),
            
            scrollView.topAnchor.constraint(equalTo: backdropImage.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            titleName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            titleName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            
            overview.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 8),
            overview.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
            
            releaseDate.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 24),
            releaseDate.leadingAnchor.constraint(equalTo: voteAverage.trailingAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -12),
            
            voteAverage.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 24),
            voteAverage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 12),
            voteAverage.trailingAnchor.constraint(equalTo: releaseDate.leadingAnchor, constant: -10),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 4),
            addToFavoritesButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10),
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
        
        backdropImage.contentMode = .scaleAspectFill
        backdropImage.clipsToBounds = true
        backdropImage.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        
        titleName.numberOfLines = 0
        titleName.lineBreakStrategy = .standard
        titleName.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        overview.numberOfLines = 0
        overview.lineBreakStrategy = .standard
        overview.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        overview.textColor = .systemGray
        
        releaseDate.numberOfLines = 1
        releaseDate.textAlignment = .right
        releaseDate.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        releaseDate.textColor = .systemGray3
        
        voteAverage.numberOfLines = 1
        voteAverage.textAlignment = .left
        voteAverage.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        voteAverage.textColor = .systemGray3
    
        addToFavoritesButton.setTitle("Add to Favorites", for: .normal)
        addToFavoritesButton.backgroundColor = .systemPink
        addToFavoritesButton.layer.cornerRadius = 8
        addToFavoritesButton.addTarget(self, action: #selector(didTapAddToFavorites), for: .touchUpInside)
        
    }
    
    // Button Functions
    @objc func didTapAddToFavorites() {
        movieDetailViewModel.didTapAddToFavorites()
    }
    
}

extension MovieDetailVC: MovieDetailDelegate {
    func didAddNewItem() {
        
    }
}
