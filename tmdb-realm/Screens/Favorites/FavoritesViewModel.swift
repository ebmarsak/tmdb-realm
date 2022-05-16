//
//  FavoritesViewModel.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol FavoritesVMDelegate : AnyObject {
    
}

final class FavoritesViewModel {
    
    weak var delegate: FavoritesVMDelegate?
    let realm = try! Realm()
    
    var favoriteMovies: [RLMMovie] = []
    
    var diffableDataSource : UITableViewDiffableDataSource<Section, RLMMovie>!
    
    init() {
        let realmData = realm.objects(RLMMovie.self)
        self.favoriteMovies = Array(realmData)
    }
    
    func updateDataSource(diffableDataSource: UITableViewDiffableDataSource<Section, RLMMovie>) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RLMMovie>()
        snapshot.appendSections([.favoritesSection])
        snapshot.appendItems(self.favoriteMovies)
        diffableDataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        print("diff snapshot updated")
    }
}


// Protocol functions
extension FavoritesViewModel : MovieDetailDelegate {
    func didAddNewItem() {
        let realmData = realm.objects(RLMMovie.self)
        self.favoriteMovies = Array(realmData)
        self.updateDataSource(diffableDataSource: self.diffableDataSource)
    }
}
