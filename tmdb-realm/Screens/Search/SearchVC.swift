//
//  SearchVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit
import RealmSwift

class SearchVC: UIViewController {
    
    let realm = try! Realm()
    
    var searchResults: [MovieInfo] = []
    var searchQuery: String?

    var searchController = UISearchController(searchResultsController: nil)
    var searchTableView = UITableView()
    var diffableDataSource : UITableViewDiffableDataSource<Section, MovieInfo>!
    
//    override func viewWillAppear(_ animated: Bool) {
//        applySnapshot()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureSearchController()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieInfo>()
        snapshot.appendSections([.searchSection])
        snapshot.appendItems(self.searchResults)
        diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Configure TableView
extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTableView.deselectRow(at: indexPath, animated: true)
        guard let selectedItem = diffableDataSource.itemIdentifier(for: indexPath) else { return }
        
        navigationController?.pushViewController(MovieDetailVC(movie: selectedItem), animated: true)
    }
    
    private func configureTableView() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: searchTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCustomCell
            
            // opt check for date
            if itemIdentifier.title != nil {
                cell.titleLabel.text = itemIdentifier.title
            } else {
                cell.titleLabel.text = "N/A"
            }
            // opt check for poster
            if itemIdentifier.posterPath != nil {
                cell.getPosterFromURL(posterPath: itemIdentifier.posterPath!)
            } else {
                cell.poster.image = UIImage(named: "poster-placeholder")
            }
            // opt check for date
            if itemIdentifier.releaseDate != nil {
                cell.releaseDate.text = "\(itemIdentifier.releaseDate!.components(separatedBy: "-")[0])"
            } else {
                cell.releaseDate.text = "Unknown Date"
            }
            // opt check for voteAverage
            if itemIdentifier.voteAverage != nil {
                cell.voteAverage.text = String(itemIdentifier.voteAverage!)
            } else {
                cell.voteAverage.text = "?.?"
            }
            // opt check for favorited movies
            if (self.realm.object(ofType: RLMMovie.self, forPrimaryKey: itemIdentifier.id) == nil) {
                cell.alreadyFavoritedButton.isHidden = true
            } else {
                cell.alreadyFavoritedButton.isHidden = false
            }
            // check for voteSymbol color
            if itemIdentifier.voteAverage! < 4.0 {
                cell.voteSymbol.image = UIImage(systemName: "heart.square")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            } else if itemIdentifier.voteAverage! < 7.0 {
                cell.voteSymbol.image = UIImage(systemName: "heart.square")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
            } else if itemIdentifier.voteAverage! < 8.0 {
                cell.voteSymbol.image = UIImage(systemName: "heart.square")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            } else {
                cell.voteSymbol.image = UIImage(systemName: "heart.square")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            }
            
            return cell
        })
        
        searchTableView.rowHeight = 130
        searchTableView.delegate = self
        searchTableView.register(SearchCustomCell.self, forCellReuseIdentifier: "searchCell")
        searchTableView.frame = view.bounds
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTableView)
    }
}
// MARK: Configure SearchController
extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchQuery = searchController.searchBar.text!
        print(self.searchQuery!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("didEndEditing")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("buttonClicked")
        getSearchResults(query: searchQuery!, page: 1)
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
    }
}

// MARK: Network calls
extension SearchVC {
    private func getSearchResults(query: String, page: Int) {
        
        let trimmedString = query.replacingOccurrences(of: " ", with: "%20")

        NetworkManager.shared.getSearchResults(query: trimmedString, page: page) { result in
            switch result {
            case .success(let searchResults):
                self.searchResults = searchResults.results
                print(searchResults)
                self.applySnapshot()
            case .failure(let error):
                print(error)
            }
        }
    }
}
