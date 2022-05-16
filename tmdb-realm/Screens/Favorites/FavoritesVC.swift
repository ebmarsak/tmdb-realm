//
//  FavoritesVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit
import RealmSwift

protocol FavoritesVCDelegate: AnyObject {
    func isAlreadyInFavorites(id: Int) -> Bool
}

class FavoritesVC: UIViewController, FavoritesViewModelDelegate {
    let favoritesTableView = UITableView()
    
    weak var delegate: FavoritesVCDelegate?
    private let favoritesViewModel = FavoritesViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        favoritesViewModel.delegate = self

        configureTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoritesViewModel.didAddNewItem()
    }
}

// MARK: TableView Configuration
extension FavoritesVC: UITableViewDelegate {
    func configureTableview() {
        favoritesViewModel.diffableDataSource = UITableViewDiffableDataSource(tableView: favoritesTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = self.favoritesTableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesCustomCell
            cell.id = itemIdentifier.id
            cell.titleLabel.text = itemIdentifier.title
            cell.getPosterFromURL(posterPath: itemIdentifier.poster)
            return cell
        })
        
        favoritesTableView.delegate = self
        favoritesTableView.register(FavoritesCustomCell.self, forCellReuseIdentifier: "favoritesCell")
        favoritesTableView.frame = view.bounds
        favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        favoritesTableView.rowHeight = 110
        view.addSubview(favoritesTableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        favoritesTableView.deselectRow(at: indexPath, animated: true)
        let currentCell = favoritesTableView.cellForRow(at: indexPath) as! FavoritesCustomCell
        // Remove item confirmation alert and related realm + diffableDataSource operations
        self.present(favoritesViewModel.didTapFavoriteCell(tappedCell: currentCell, indexPath: indexPath), animated: true, completion: nil)
    }
}
