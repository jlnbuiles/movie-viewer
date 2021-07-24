//
//  MoviesRepository.swift
//  MovieViewer
//
//  Created by builes on 24/07/21.
//

import Foundation

// TODO: maybe we can create a protocol that is implemented by all entities?
// it could use generics 🤔

/**
 This is an abstraction layer that allows the app to use a local custom caching system when certain rules are met.
 
 This  reduces the amount of requests & load time. Additionally some partial offline funcionality.
 
 - Author:  Julian Builes
 */
class MovieRepository {
    
    class func GETMovies(for category: MovieCategory, completion: @escaping MovieQueryResults) {
        
        let cacheManager = MovieCacheManager.sharedCacheManager()
        
        // Check if we should call movies request, or get fresh movies from cache
        if cacheManager.shouldRefreshMoviesFromServer(category: category) {
            MovieDBHTTPClient().GETMovies(for: category) { movies, errorString in
                completion(movies, errorString)
                if let theMovies = movies { cacheManager.saveToCache(movies: theMovies, category: category) }
            }
        } else {// get them from cache
            completion(cacheManager.fetchCachedMovies(for: category), nil)
        }
    }
}
