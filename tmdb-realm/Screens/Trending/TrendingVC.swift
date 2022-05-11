//
//  TrendingVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit

enum Section {
    case trendingSection
}

class TrendingVC: UIViewController {
    
    private let trendingViewModel = TrendingViewModel()
    
    let trendingTableView = UITableView()
    var diffableDataSource : UITableViewDiffableDataSource<Section, Result>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        trendingViewModel.delegate = self
        trendingViewModel.getTrendingMovies(completion: updateDataSource)
        
        configureTableview()
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
            cell.popularity.text = String(itemIdentifier.popularity)
            cell.getPosterFromURL(posterPath: itemIdentifier.posterPath)
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Result>()
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
//        print("tık")
    }
}
