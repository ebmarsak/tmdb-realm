//
//  FavoritesViewModel.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol FavoritesViewModelDelegate : AnyObject { }

final class FavoritesViewModel {
    
    weak var delegate: FavoritesViewModelDelegate?

    var diffableDataSource : UITableViewDiffableDataSource<Section, RLMMovie>!
    let realm = try! Realm()
    
    var favoriteMovies: [RLMMovie] = []
    
    init() {
        let realmData = realm.objects(RLMMovie.self)
        self.favoriteMovies = Array(realmData)
    }
    
    // Update DiffableDataSourceSnapshot using Realm Object
    func updateDataSource(diffableDataSource: UITableViewDiffableDataSource<Section, RLMMovie>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RLMMovie>()
        snapshot.appendSections([.favoritesSection])
        snapshot.appendItems(self.favoriteMovies)
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        print("diff snapshot updated")
    }
    
    // Remove item confirmation alert and related realm + diffableDataSource operations
    func didTapFavoriteCell(tappedCell: FavoritesCustomCell, indexPath: IndexPath) -> UIAlertController {
        
        let alert = UIAlertController(title: "Remove from list", message: "\(tappedCell.titleLabel.text!) will be deleted from your favorites list. Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: {(alert: UIAlertAction!) in
            var snapshot = self.diffableDataSource.snapshot()
            if let item = self.diffableDataSource.itemIdentifier(for: indexPath) {
                    snapshot.deleteItems([item])
                self.diffableDataSource.apply(snapshot)
                }
            let itemToRemove = self.realm.object(ofType: RLMMovie.self, forPrimaryKey: tappedCell.id)

            try! self.realm.write({ self.realm.delete(itemToRemove!) })
            }))
        return alert
    }
}

// Protocol functions
extension FavoritesViewModel : MovieDetailDelegate {
    func updateRealmDB() {
        let realmData = realm.objects(RLMMovie.self)
        self.favoriteMovies = Array(realmData)
        self.updateDataSource(diffableDataSource: self.diffableDataSource)
    }
}
