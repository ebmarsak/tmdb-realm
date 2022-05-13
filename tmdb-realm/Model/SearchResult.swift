//
//  SearchResult.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 13.05.2022.
//

import Foundation

// MARK: - SearchResult
struct SearchResult: Codable {
    let page: Int
    let response: [Response]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case response = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Response
struct Response: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let id: Int?
    let originalTitle: String?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case id = "id"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
