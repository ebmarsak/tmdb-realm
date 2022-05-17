//
//  Enum.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation

// DiffableDataSource sections
enum Section {
    case trendingSection
    case favoritesSection
    case searchSection
}

// Movie network call parameters
enum trendingMediaType : String {
    case all = "all"
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}

enum trendingTimeWindow : String {
    case day = "day"
    case week = "week"
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}
