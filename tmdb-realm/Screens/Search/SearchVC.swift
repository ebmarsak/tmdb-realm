//
//  SearchVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    var searchResults: [Response] = []
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchTableView = UITableView()
    var diffableDataSource : UITableViewDiffableDataSource<Section, Response>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureSearchController()
        getSearchResults(query: "batman", page: 1)
        
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Response>()
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
        // push movieDetailVC with selected movie cell
    }
    
    private func configureTableView() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: searchTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = UITableViewCell()
            return cell
            // TODO:
        })
        
        searchTableView.delegate = self
        searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchTableView.frame = view.bounds
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchTableView)
    }
}

// MARK: Configure SearchController
extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    
}

// MARK: Network calls

extension SearchVC {
    private func getSearchResults(query: String, page: Int) {
        NetworkManager.shared.getSearchResults(query: query, page: page) { result in
            switch result {
            case .success(let searchResults):
                self.searchResults = searchResults.response
                print(searchResults)
            case .failure(let error):
                print(error)
            }
        }
    }
}
