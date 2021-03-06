//
//  NetworkManager.swift
//  tmdb-realm
//
//  Created by Emre Beytullah Marsak  on 6.05.2022.
//

import Foundation
import UIKit

fileprivate let apiKey = "499ba6f1ac8132dc1bf6b8047c0cb1d8"
fileprivate let baseURL = "https://api.themoviedb.org/3"
fileprivate let imgBaseURL = "https://image.tmdb.org/t/p/original/"

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // GET search results
    func getSearchResults(query: String, page: Int, completed: @escaping (Swift.Result<MovieRequest, Error>) -> Void) {
        
        let endpoint = "\(baseURL)/search/movie?api_key=\(apiKey)&language=en-US&query=\(query)&page=\(page)"
        
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let searchResult = try decoder.decode(MovieRequest.self, from: data)
                completed(.success(searchResult))
            } catch {
                return
            }
        }
        task.resume()
    }
    
    // GET trending movies
    func getTrendingMovies(contentType mediatype: trendingMediaType, timePeriod timeWindow: trendingTimeWindow, completed: @escaping (Swift.Result<MovieRequest, Error>) -> Void) {
        
        let endpoint = "\(baseURL)/trending/\(mediatype)/\(timeWindow)?api_key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let movies = try decoder.decode(MovieRequest.self, from: data)
                completed(.success(movies))
            } catch {
                return
            }
        }
        task.resume()
    }
    
    // GET movie by ID
    func getMovieByID(movieID id: Int, completed: @escaping (Swift.Result<MovieInfo, Error>) -> Void) {
        
        let endpoint = "\(baseURL)/movie/\(id)?api_key=\(apiKey)"
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let movie = try decoder.decode(MovieInfo.self, from: data)
                completed(.success(movie))
            } catch {
                return
            }
        }
        task.resume()
    }
    
    // GET Poster image for a movie with posterPath
    func getPosterImage(posterPath: String, completion: @escaping (UIImage) -> ()) {
        
        let url: String = imgBaseURL + posterPath
        
        guard let url = URL(string: url) else {
            return
        }
        
        let img = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            completion(UIImage(data: data)!)
        }
        img.resume()
    }
    
    // GET Backdrop image for a movie with backdropPath
    func getBackdropImage(backdropPath: String, completion: @escaping (UIImage) -> ()) {
        
        let url: String = imgBaseURL + backdropPath
        
        guard let url = URL(string: url) else {
            return
        }
        
        let img = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            completion(UIImage(data: data)!)
        }
        img.resume()
    }
}



