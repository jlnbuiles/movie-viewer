//
//  File.swift
//  MovieViewer
//
//  Created by builes on 23/07/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    // TODO: configure cache. if we already have image, don't fetch it
    func setImage(with URL: URL?) {
        
        if let url = URL as URL? {
            
            // This line seems to be randomly throwing a warning that appears to be a swift bug
            // which does not affect funtionality. As seen here:
            // 1. https://github.com/ctreffs/SwiftSimctl/issues/10
            // 2. https://developer.apple.com/forums/thread/665599
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                guard let data = data, error == nil else {
                    print("Unable to fetch image for URL: \(url.absoluteString))" +
                            " with error \(error?.localizedDescription ?? "")")
                    return
                }
                
                // Update UI on main thread
                DispatchQueue.main.async() { [weak self] in
                    self?.image = UIImage(data: data)
                }
            }.resume()
        } else {
            print("Invalid URL \(String(describing: URL))")
        }
    }
}

extension UIAlertController{
    class func unableToFetchMovieDataAlert() -> UIAlertController {
        return UIAlertController(title: "Unexpected Error",
                                            message: "We were unable to fetch movie data. Please try again later.",
                                            preferredStyle: .alert)
    }
}
