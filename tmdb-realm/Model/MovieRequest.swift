//
//  MovieRequest.swift
//  tmdb-realm
//
//  Created by Emre Beytullah MARSAK on 16.05.2022.
//

import Foundation

struct MovieRequest: Codable, Hashable {
    let page: Int
    let results: [MovieDetail]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct MovieDetail: Codable, Hashable {
    let id: Int

    let title: String?
    let name: String?
    let originalTitle: String?
    let originalName: String?

    let overview: String
    let releaseDate: String?

    let posterPath: String?
    let backdropPath: String?
    let adult: Bool?
    let video: Bool?

    let voteCount: Int?
    let voteAverage: Double?
    let mediaType: MediaType?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"

        case title = "title"
        case name = "name"
        case originalTitle = "original_title"
        case originalName = "original_name"

        case overview = "overview"
        case releaseDate = "release_date"

        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case adult = "adult"
        case video = "video"

        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
    }
}
