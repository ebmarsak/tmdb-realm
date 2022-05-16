//
//  TrendingVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit
import RealmSwift

// TODO: fix diffableDataSource still existing inside TrendingVC

class TrendingVC: UIViewController {
    
    let realm = try! Realm()
    
    private let trendingViewModel = TrendingViewModel()
    
    let trendingTableView = UITableView()
    var diffableDataSource : UITableViewDiffableDataSource<Section, MovieDetail>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        trendingViewModel.delegate = self
        trendingViewModel.getTrendingMovies(completion: updateDataSource)
        
        configureTableview()
        
//        path for realm db
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

// MARK: TableView Configuration
extension TrendingVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trendingTableView.deselectRow(at: indexPath, animated: true)
        guard let selectedItem = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        
        trendingViewModel.didTapMovieCell(movieID: selectedItem.id)
        navigationController?.pushViewController(MovieDetailVC(movie: selectedItem), animated: true)
    }
    
    func configureTableview() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: trendingTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = self.trendingTableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! MovieCustomCell
            cell.titleLabel.text = itemIdentifier.title
            cell.voteAverage.setTitle(" \(String(itemIdentifier.voteAverage!)) ", for: .normal)
            cell.getPosterFromURL(posterPath: itemIdentifier.posterPath!)
            
            // vote average check
            if itemIdentifier.voteAverage! < 4.0 {
                cell.voteAverage.setTitleColor(.systemRed, for: .normal)
            } else if itemIdentifier.voteAverage! < 7.0 {
                cell.voteAverage.setTitleColor(.systemOrange, for: .normal)
            } else if itemIdentifier.voteAverage! < 8.0 {
                cell.voteAverage.setTitleColor(.systemYellow, for: .normal)
            } else {
                cell.voteAverage.setTitleColor(.systemGreen, for: .normal)
            }
            
            // isAlreadyFavorite check
            cell.alreadyFavoritedButton.isHidden = self.isAlreadyInFavorites(id: itemIdentifier.id)
            
            return cell
        })
        
        trendingTableView.delegate = self
        trendingTableView.register(MovieCustomCell.self, forCellReuseIdentifier: "trendingCell")
        trendingTableView.frame = view.bounds
        trendingTableView.translatesAutoresizingMaskIntoConstraints = false
        trendingTableView.rowHeight = 310
        view.addSubview(trendingTableView)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieDetail>()
        snapshot.appendSections([.trendingSection])
        snapshot.appendItems(self.trendingViewModel.trendingMovies)
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

extension TrendingVC: TrendingVMDelegate {
    func didFetchTrendingMovies() {
        DispatchQueue.main.async { self.updateDataSource() }
    }
    
    func didFetchMovieDetails() {
    }
}

extension TrendingVC: FavoritesVCDelegate {
    func isAlreadyInFavorites(id: Int) -> Bool {
        return realm.object(ofType: RLMMovie.self, forPrimaryKey: id) == nil
    }
}

