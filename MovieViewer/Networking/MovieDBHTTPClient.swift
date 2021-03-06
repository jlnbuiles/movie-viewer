//
//  MovieDBHTTPClient.swift
//  MovieViewer
//
//  Created by builes on 20/07/21.
//

import Foundation
// top rated list: 7102182
// popular list: 7102183
// upcoming list: 7102184

let API_KEY_VALUE = "ef8c9b33aa5def87ccab12278f7929eb"
let MOVIE_DB_BASE_URL = "https://api.themoviedb.org"
let API_KEY_URL_PARAM = "api_key"
let API_KEY_QUERY_COMPONENTS = URLQueryItem(name: API_KEY_URL_PARAM, value: API_KEY_VALUE)
let MID_IMG_BASE_URL = "https://image.tmdb.org/t/p/w500"

/**
 A simple yet declarative way to represent the URL paths.
 
 - Author:  Julian Builes
 */
private enum MoviesDBURLPath {

    case list, details
    
    func toString(withID: String) -> String {
        switch self {
        case .list:
            return "/4/list/" + withID
        case .details:
            return "/4/movie/" + withID
        }
    }
}

// MARK: - Type Alias
typealias MovieQueryResults = ([Movie]?, String?) -> Void

/**
    Layer that interacts with the movieDB web services.
 
    - Author:  Julian Builes
 */
class MovieDBHTTPClient {
    
    // MARK: - Properties
    private let defaultSession = URLSession(configuration: .default)
    
    // MARK: - Instance Methods
    private func URL(category: MovieCategory) -> URL? {
        
        if var urlComponents = URLComponents(string: MOVIE_DB_BASE_URL) {
            let categoryString = category.externalID()
            urlComponents.path = MoviesDBURLPath.list.toString(withID: categoryString)
            urlComponents.queryItems = [API_KEY_QUERY_COMPONENTS]
            
            if let url = urlComponents.url {
                return url
            }
        }
        print("Unable to create URL for category \(category.externalID())")
        return nil
    }
    
    func GETMovies(for category: MovieCategory, completion: @escaping MovieQueryResults) {
        
        if let url = URL(category: category) {

            let dataTask = defaultSession.dataTask(with: url) {
                data, response, error in
                
                    var movieResults:[Movie]?, errorMsg: String?
                
                    if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {// The request was successful!
                        movieResults = self.decode(JSONMoviesData: data)
                    } else {
                        errorMsg = error?.localizedDescription
                        print("failed request with Response \(String(describing: response))" +
                                "error \(String(describing: error?.localizedDescription))")
                    }
                
                    DispatchQueue.main.async { completion(movieResults, errorMsg) }
            }
            dataTask.resume()
        }
    }
    
    private func decode(JSONMoviesData: Data) -> [Movie] {
        
        do {
            if let responseDict = try JSONSerialization.jsonObject(with: JSONMoviesData,
                                                                   options: []) as? [String: Any],
               let responseArray = responseDict["results"] as? [[String: Any]] {
                
                var decodedMovies:[Movie] = []
                
                for movieJSON in responseArray {
                    let movie = try Movie.init(JSON: movieJSON)
                    decodedMovies.append(movie)
                }
                return decodedMovies
            }
            
            print("Encountered an error while serializing JSON data \(JSONMoviesData)")
            return []
            
        } catch let parseError as NSError {
            print("Encountered JSONSerialization error: \(parseError.localizedDescription)\n")
            return []
        }
    }
}
