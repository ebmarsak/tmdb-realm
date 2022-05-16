//
//  FavoritesVC.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import UIKit
import RealmSwift

protocol FavoritesVCDelegate : AnyObject {
    func isAlreadyInFavorites(id: Int) -> Bool
}

class FavoritesVC: UIViewController {
    
    let favoritesTableView = UITableView()
//    var diffableDataSource : UITableViewDiffableDataSource<Section, RLMMovie>!
    
//    let realm = try! Realm()
    weak var delegate: FavoritesVCDelegate?
    
    private let favoritesViewModel = FavoritesViewModel()
    
//    var favoriteMovies: [RLMMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        favoritesViewModel.delegate = self
        
//        let realmData = favoritesViewModel.realm.objects(RLMMovie.self)
//        favoritesViewModel.favoriteMovies = Array(realmData)
        
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
//            self.delegate?.isAlreadyInFavorites(id: itemIdentifier.id)
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
        let alert = UIAlertController(title: "Remove from list", message: "\(currentCell.titleLabel.text!) will be deleted from your favorites list. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {(alert: UIAlertAction!) in
            var snapshot = self.favoritesViewModel.diffableDataSource.snapshot()
            if let item = self.favoritesViewModel.diffableDataSource.itemIdentifier(for: indexPath) {
                    snapshot.deleteItems([item])
                self.favoritesViewModel.diffableDataSource.apply(snapshot)
                }
            let itemToRemove = self.favoritesViewModel.realm.object(ofType: RLMMovie.self, forPrimaryKey: currentCell.id)

            try! self.favoritesViewModel.realm.write({ self.favoritesViewModel.realm.delete(itemToRemove!) })
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension FavoritesVC: FavoritesVMDelegate {
    
}
