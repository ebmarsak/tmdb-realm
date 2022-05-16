//
//  TrendingViewModel.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 10.05.2022.
//

import Foundation
import RealmSwift

protocol TrendingVMDelegate : AnyObject {
    func didFetchTrendingMovies()
    func didFetchMovieDetails()
}

final class TrendingViewModel {
    
    weak var delegate: TrendingVMDelegate?
    let realm = try! Realm()
    
    var trendingMovies: [MovieInfo] = []

    // ViewModel functions
    func didTapMovieCell(movieID: Int) {
        fetchMovieDetails(movieID: movieID)
    }
    
    // Network Calls
    func getTrendingMovies(completion: @escaping () -> ()) {
        NetworkManager.shared.getTrendingMovies(contentType: .movie, timePeriod: .week) { result in
            switch result {
            case .success(let movies):
                self.trendingMovies = movies.results
//                self.delegate?.didFetchTrendingMovies()
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMovieDetails(movieID: Int) {
        NetworkManager.shared.getMovieByID(movieID: movieID) { result in
            switch result {
            case .success(let movie):
                self.delegate?.didFetchMovieDetails()
            case .failure(let error):
                print(error)
            }
        }
    }
}
