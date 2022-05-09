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

class TrendingVC: UIViewController, UITableViewDelegate {
    
    let trendingTableView = UITableView()
    var diffableDataSource : UITableViewDiffableDataSource<Section, Result>!
    
    var trendingMovies: [Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        getTrendingMovies()
        configureTableview()
    }
}


// MARK: TableView Configuration
extension TrendingVC {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        trendingTableView.deselectRow(at: indexPath, animated: true)
        guard let selectedItem = diffableDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print(selectedItem.title!)
    }
    
    func configureTableview() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: trendingTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            
            let cell = self.trendingTableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.title
            return cell
        })
        
        trendingTableView.delegate = self
        trendingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "trendingCell")
        trendingTableView.frame = view.bounds
        trendingTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trendingTableView)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Result>()
        snapshot.appendSections([.trendingSection])
        snapshot.appendItems(trendingMovies)
        
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
}

// MARK: Network calls
extension TrendingVC {
    func getTrendingMovies() {
        NetworkManager.shared.getTrendingMovies(contentType: .movie, timePeriod: .week) { result in
            switch result {
            case .success(let movies):
                self.trendingMovies = movies.results
                DispatchQueue.main.async {
                    self.updateDataSource()
                }
            case .failure(let error):
                print(error)
        }
    }
}
    
    func getMovie(id: Int) {
        NetworkManager.shared.getMovieByID(movieID: id) { result in
            switch result {
            case .success(let movie):
                print(movie)
            case .failure(let error):
                print(error)
            }
        }
    }
}
