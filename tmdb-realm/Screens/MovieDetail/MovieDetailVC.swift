//
//  MovieDetailVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 10.05.2022.
//

import UIKit
import AVFoundation

class MovieDetailVC: UIViewController {

    var backdropImage = UIImageView()
    var titleName = UILabel()
    var releaseDate = UILabel()
    var overview = UILabel()
    let addToFavoritesButton = UIButton()
//    let video = AVPlayer
    
    var movie: Result
    
    init(movie: Result) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getBackdropFromURL(backdropPath: movie.backdropPath)
        setProperties()
        configLayout()
    }
    // Set properties
    func setProperties() {
        titleName.text = movie.title
        overview.text = movie.overview
        releaseDate.text = "Release Date: \(movie.releaseDate!)"
    }
    
    // Config Layout
    func configLayout() {
        view.addSubview(backdropImage)
        view.addSubview(titleName)
        view.addSubview(overview)
        view.addSubview(releaseDate)
        view.addSubview(addToFavoritesButton)
        
        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        titleName.translatesAutoresizingMaskIntoConstraints = false
        releaseDate.translatesAutoresizingMaskIntoConstraints = false
        overview.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backdropImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backdropImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropImage.heightAnchor.constraint(equalToConstant: view.bounds.width),
            backdropImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleName.topAnchor.constraint(equalTo: backdropImage.bottomAnchor, constant: 10),
            titleName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            overview.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 8),
            overview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            releaseDate.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 24),
            releaseDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            releaseDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: releaseDate.bottomAnchor, constant: 4),
            addToFavoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
        
        backdropImage.contentMode = .scaleAspectFill
        backdropImage.clipsToBounds = true
        
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
    
        addToFavoritesButton.setTitle("Add to Favorites", for: .normal)
        addToFavoritesButton.backgroundColor = .systemPink
        addToFavoritesButton.layer.cornerRadius = 8
        
    }
    // Network Call
    func getBackdropFromURL(backdropPath: String){
        NetworkManager.shared.getBackdropImage(backdropPath: backdropPath) { image in
            DispatchQueue.main.async {
                self.backdropImage.image = image
            }
        }
    }
}
