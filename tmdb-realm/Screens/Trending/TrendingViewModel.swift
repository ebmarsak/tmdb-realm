//
//  TrendingViewModel.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 10.05.2022.
//

import Foundation
import UIKit

protocol TrendingViewModelDelegate: AnyObject {
    func didFetchMovieDetails()
}

final class TrendingViewModel {
    weak var delegate: TrendingViewModelDelegate?
//    weak var movieDetailDelegate: MovieDetailDelegate?

    var trendingMovies: [MovieInfo] = []
    var diffableDataSource : UITableViewDiffableDataSource<Section, MovieInfo>!
    
    // Chose color for voteAverage
    func voteAverageColorCheck(voteAverage: Double) -> UIColor {
        if voteAverage < 4.0 {
            return .systemRed
        } else if voteAverage < 7.0 {
            return .systemOrange
        } else if voteAverage < 8.0 {
            return .systemYellow
        } else {
            return .systemGreen
        }
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieInfo>()
        snapshot.appendSections([.trendingSection])
        snapshot.appendItems(self.trendingMovies)
        self.diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }

    // ViewModel functions
    func didTapMovieCell(movieID: Int) {
        fetchMovieDetails(movieID: movieID)
    }
    
    // Network Calls
    func getTrendingMovies() {
        NetworkManager.shared.getTrendingMovies(contentType: .movie, timePeriod: .week) { result in
            switch result {
            case .success(let movies):
                self.trendingMovies = movies.results
                self.updateDataSource()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchMovieDetails(movieID: Int) {
        NetworkManager.shared.getMovieByID(movieID: movieID) { result in
            switch result {
            case .success(_):
                self.delegate?.didFetchMovieDetails()
            case .failure(let error):
                print(error)
            }
        }
    }
    func applyChangesToSnapshot() {
        var snp = diffableDataSource.snapshot()
        snp.reloadItems(self.trendingMovies)
        diffableDataSource.applySnapshotUsingReloadData(snp)
        print("refreshing diff db")
    }
}

//extension TrendingViewModel: MovieDetailViewDelegate {
//    func didTapFavoriteButton() {
//        applyChangesToSnapshot()
//    }
//}
