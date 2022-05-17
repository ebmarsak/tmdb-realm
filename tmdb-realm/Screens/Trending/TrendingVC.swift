//
//  TrendingVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit
import RealmSwift

class TrendingVC: UIViewController {
    
    let realm = try! Realm()
    
    private let trendingViewModel = TrendingViewModel()
    
    let trendingTableView = UITableView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        trendingViewModel.delegate = self
        trendingViewModel.getTrendingMovies()
        
        configureTableview()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyChangesToSnapshot()
    }
    
    func applyChangesToSnapshot() {
        var snp = trendingViewModel.diffableDataSource.snapshot()
        snp.reloadItems(self.trendingViewModel.trendingMovies)
        trendingViewModel.diffableDataSource.applySnapshotUsingReloadData(snp)
        print("refreshing diff db")
    }
}

// MARK: TableView Configuration
extension TrendingVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trendingTableView.deselectRow(at: indexPath, animated: true)
        guard let selectedItem = trendingViewModel.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        
        trendingViewModel.didTapMovieCell(movieID: selectedItem.id)
        navigationController?.pushViewController(MovieDetailVC(movie: selectedItem), animated: true)
    }
    
    private func configureTableview() {
        trendingViewModel.diffableDataSource = UITableViewDiffableDataSource(tableView: trendingTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = self.trendingTableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! MovieCustomCell
            
            cell.titleLabel.text = itemIdentifier.title
            cell.voteAverage.setTitle(" \(String(itemIdentifier.voteAverage!)) ", for: .normal)
            cell.getPosterFromURL(posterPath: itemIdentifier.posterPath!)
                        
            cell.voteAverage.setTitleColor(self.trendingViewModel.voteAverageColorCheck(voteAverage: itemIdentifier.voteAverage!), for: .normal)
            
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
}

// MARK: Delegation
extension TrendingVC: TrendingViewModelDelegate {
    func didFetchMovieDetails() {
    }
}

extension TrendingVC: FavoritesVCDelegate {
    func isAlreadyInFavorites(id: Int) -> Bool {
        return realm.object(ofType: RLMMovie.self, forPrimaryKey: id) == nil
    }
}
