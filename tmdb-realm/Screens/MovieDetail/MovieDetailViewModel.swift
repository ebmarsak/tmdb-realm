//
//  MovieDetailViewModel.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation
import RealmSwift
import UIKit

final class MovieDetailViewModel {

    weak var delegate: MovieDetailDelegate?
    let realm = try! Realm()
    
    var movie: MovieInfo!
    
    
    // Network Call
    func getBackdropFromURL(backdropPath: String, backdropView: UIImageView) {
        NetworkManager.shared.getBackdropImage(backdropPath: backdropPath) { image in
            DispatchQueue.main.async {
                backdropView.image = image
            }
        }
    }
    
    // Button Functions
    func didTapAddToFavorites() {
        try! realm.write({
            let movie = RLMMovie()
            movie.title = self.movie.title!
            movie.id = self.movie.id
            movie.poster = self.movie.posterPath!
            realm.add(movie, update: .modified)
            print("Name: \(movie.title) ID: \(movie.id) || Added to realm")
        })
        self.delegate?.didAddNewItem()
    }
    

}

