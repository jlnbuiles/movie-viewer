//
//  Movie.swift
//  MovieViewer
//
//  Created by builes on 20/07/21.
//

import Foundation

enum MovieType {
    case other, toprated, popular, upcoming
}

class Movie: BaseModel {
    
    // MARK: - Properties
    var title: String?
    var overview: String?
    var releaseDate: Date?
    // There is also a backdrop path very suitable for this details view but it sometimes returns null, so skipping for now.
    var imageURL: URL?
    var popularity = 0.0
    
    // make private for built-in dispatch once. ref: https://developer.apple.com/swift/blog/?id=7
    private static let sharedDF = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        df.dateFormat = "yyyy-MM-dd"
        return df
    }() as DateFormatter
    
    // TODO logic for movie type
    var type = MovieType.other
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
    
    static func sharedDateFormatter() -> DateFormatter {
        return Movie.sharedDF
    }
    
    override init(JSON: [String: Any]) throws {
        
        try super.init(JSON: JSON)
        // TODO: more profound and less fragile error handling. maybe
        if let overview = JSON["overview"] as? String,
           let popularity = JSON["popularity"] as? Double,
           let imgPath = JSON["poster_path"] as? String,
           let imgURL = URL(string: MID_IMG_BASE_URL + imgPath) {
            self.overview = overview
            self.popularity = popularity
            self.imageURL = imgURL
        } else {
            print("Unable to map fields for response movie object \(JSON)")
        }
        
        // The API seems to send the name in different keys depending on the movie 😅
        if let title = (JSON["title"] ?? JSON["name"]) as? String {
            self.title = title
        } else {
            print("Unable to get title for json object \(JSON)")
            throw JSONSerializationError.missing("name")
        }
        
        self.releaseDate = try dateFrom(JSON: JSON)
    }
    
    private func dateFrom(JSON: [String: Any]) throws -> Date? {
        
        if let releaseDateStr = (JSON["release_date"] ?? JSON["air_date"]) as? String {
                
            if let date = Movie.sharedDF.date(from:releaseDateStr) {
                return date
            }
            print("Unable to get release date for json object \(JSON)")
        }
        return nil
    }
}

