//
//  MovieDetailsVC.swift
//  MovieViewer
//
//  Created by builes on 21/07/21.
//

import UIKit

class MovieDetailsVC: UIViewController {

    // TODO: add scrollview to allow for dynamic length overview label
    // TODO: possibly use a UIStackView for all side labels instead
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewTitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var releaseDateTitleabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityTitleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    

    // MARK: - Properties
    var movie: Movie!
    
    // MARK: - Initializers
    init?(coder: NSCoder, theMovie: Movie) {
        movie = theMovie
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No movie was provided. please provide a movie using init(coder: theMovie: ) instead")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Detailsspa"
        configureFields(with: movie)
    }
    
    // MARK: - UI Configuration
    private func configureFields(with theMovie: Movie) {
        popularityLabel.text = String(theMovie.popularity)
        
        overviewLabel.text = theMovie.overview
        overviewLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        
        if let releaseDate = theMovie.releaseDate {
            releaseDateLabel.text = Movie.sharedDateFormatter().string(from: releaseDate)
        }
        
        imageView.setImage(with: movie.imageURL)
        // how to cache images. we already dowloaded them
    }
}
