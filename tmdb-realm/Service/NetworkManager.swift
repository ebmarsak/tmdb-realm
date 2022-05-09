//
//  NetworkManager.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import Foundation

fileprivate let apiKey = "499ba6f1ac8132dc1bf6b8047c0cb1d8"
fileprivate let baseUrl = URL(string: "https://api.themoviedb.org/3")!


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

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getTrendingMovies(contentType mediatype: trendingMediaType, timePeriod timeWindow: trendingTimeWindow, completed: @escaping (Swift.Result<Movies, Error>) -> Void) {
        
        let endpoint = "\(baseUrl)/trending/\(mediatype)/\(timeWindow)?api_key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode(Movies.self, from: data)
                completed(.success(movies))
            } catch {
                return
            }
        }
        task.resume()
    }
    
    func getMovieByID(movieID id: Int, completed: @escaping (Swift.Result<Movie, Error>) -> Void) {
        
        let endpoint = "\(baseUrl)/movie/\(id)?api_key=\(apiKey)"
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(Movie.self, from: data)
                completed(.success(movie))
            } catch {
                return
            }
        }
        task.resume()
    }
    
}



