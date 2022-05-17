//
//  RLMMovie.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 11.05.2022.
//

import Foundation
import RealmSwift

class RLMMovie: Object {
    @Persisted var id: Int
    @Persisted var title: String
    @Persisted var poster: String
    @Persisted var addedDate: Date
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
