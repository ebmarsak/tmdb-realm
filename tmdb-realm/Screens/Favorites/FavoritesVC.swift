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
    var diffableDataSource : UITableViewDiffableDataSource<Section, RLMMovie>!
    
    let realm = try! Realm()
    weak var delegate: FavoritesVCDelegate?
    
    var favoriteMovies: [RLMMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Favorites"
        
        let realmData = realm.objects(RLMMovie.self)
        favoriteMovies = Array(realmData)
        
        configureTableview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        didAddNewItem()
    }

}

// MARK: TableView Configuration
extension FavoritesVC: UITableViewDelegate {
    func configureTableview() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: favoritesTableView, cellProvider: { tableView, indexPath, itemIdentifier in
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
                var snapshot = self.diffableDataSource.snapshot()
                if let item = self.diffableDataSource.itemIdentifier(for: indexPath) {
                    snapshot.deleteItems([item])
                    self.diffableDataSource.apply(snapshot)
                }
                let itemToRemove = self.realm.object(ofType: RLMMovie.self, forPrimaryKey: currentCell.id)

                try! self.realm.write({ self.realm.delete(itemToRemove!) })
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RLMMovie>()
        snapshot.appendSections([.favoritesSection])
        snapshot.appendItems(self.favoriteMovies)
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        print("diff snapshot updated")
    }
}

// Protocol functions
extension FavoritesVC : MovieDetailDelegate {
    func didAddNewItem() {
        let realmData = realm.objects(RLMMovie.self)
        self.favoriteMovies = Array(realmData)
        self.updateDataSource()
    }
}
