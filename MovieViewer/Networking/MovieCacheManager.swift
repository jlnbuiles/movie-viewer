//
//  MovieCacheManager.swift
//  MovieViewer
//
//  Created by builes on 24/07/21.
//

import Foundation

typealias CashedCollection = (lastUpdatedAt: Date?, movies: [Movie])
typealias CacheStore = [MovieCategory: CashedCollection]

// Maybe this could be replaced/complemented by realm or Core Data

/**
 How long movies are considered current for. Expressed in seconds.
 
 Once the threshold is passed, movies should be fetched from server.
 
 max - 24 hours
 min - 60 seconds. Use this to provide a more fluid & data independent experience.
 
 Movies could still be fresh within the current session and MAY NOT have to be fetched, in most scenarios.
 */
enum CacheConfig {
    case min, max
    
    func value() -> Int {
        switch self {
        case .max:
            return 86_400
        case .min:
            return 60
        }
    }
}

/**
 A simple local cache implementation for the movie model.
 When requests for a movie category are successul, movies are persisted in this object along with a time stamp (see CachedCollection.lastSavedAt).
 
 Call this object before making a request to verify if you have current movie data and hence can avoid a trip to the server.
 
 - Author:  Julian Builes
 */

// Make Thread safe. could there be a possibility that different threads cache info into different cache stores?
class MovieCacheManager {
    
    // MARK: - Properties
    private static let sharedMovieCacheManager = MovieCacheManager()
    private var cacheConfig = CacheConfig.max
    
    private var cacheStore = {
        
        let topRatedCollection = CashedCollection(lastUpdatedAt: nil, movies: [Movie]())
        let popularCollection = CashedCollection(lastUpdatedAt: nil, movies: [Movie]())
        let upcomingCollection = CashedCollection(lastUpdatedAt: nil, movies: [Movie]())
        
        let theMovieStore: CacheStore = [
            MovieCategory.toprated: topRatedCollection,
            MovieCategory.upcoming: topRatedCollection,
            MovieCategory.popular: popularCollection
        ]
        return theMovieStore
    }() as CacheStore
    
    // MARK: - Initializers
    // make private to prevent anyone from initializing this outside of the class.
    private init() {}
    
    // MARK: - Singleton instance accesor
    class func sharedCacheManager() -> MovieCacheManager {
        return sharedMovieCacheManager
    }
    
    func fetchCachedMovies(for category: MovieCategory) -> [Movie] {
        if let cachedCollection = cacheStore[category] {
            return cachedCollection.movies
        }
        return [Movie]()
    }
    
    // could cause problems in a multi-threaded environment?
    func saveToCache(movies: [Movie], category: MovieCategory) {
        cacheStore[category] = (lastUpdatedAt: Date(), movies: movies)
    }
    
    /**
        Whether we should fetch new movies according to our CacheConfig.
     
        This method will return false if:
        - we have more than one movie result
        - Results are still 'fresh' according to the CacheConfig especified
     
        It will return true otherwise.
     */
    func shouldRefreshMoviesFromServer(with config: CacheConfig = .max, category: MovieCategory) -> Bool {
        
        if let movies = cacheStore[category] {
            
            guard let lastUpdatedAt = movies.lastUpdatedAt else { return true }
            
            let noMovieResults = movies.movies.count < 1
            let lastUpdatedMS = lastUpdatedAt.timeIntervalSince1970
            let dateDifference = Int(Date().timeIntervalSince1970 - lastUpdatedMS)
            let dataIsFresh = dateDifference <= cacheConfig.value()
            
            return noMovieResults || !dataIsFresh
        }
        print("Error while fetching movies for category \(category) in cache store.")
        return true
    }
}
