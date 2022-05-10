//
//  Movie.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import Foundation
import RealmSwift

// MARK: - TrendingMovies
struct Movies: Codable, Hashable {
    let page: Int
    let results: [Result]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable, Hashable {
    let overview: String
    let releaseDate: String?
    let adult: Bool?
    let backdropPath: String
    let voteCount: Int
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String?
    let posterPath: String
    let title: String?
    let video: Bool?
    let voteAverage: Double
    let popularity: Double
    let mediaType: MediaType
    let originalName: String?
    let originCountry: [String]?
    let firstAirDate: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case overview = "overview"
        case releaseDate = "release_date"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case genreIDS = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case mediaType = "media_type"
        case originalName = "original_name"
        case originCountry = "origin_country"
        case firstAirDate = "first_air_date"
        case name = "name"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}
