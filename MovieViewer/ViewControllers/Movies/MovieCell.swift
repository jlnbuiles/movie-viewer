//
//  MovieCell.swift
//  MovieViewer
//
//  Created by builes on 20/07/21.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var categoryLabel: UILabel?
    @IBOutlet var releaseDateLabel: UILabel?
    @IBOutlet var thumbnailImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with movie: Movie, formatter: DateFormatter) -> MovieCell {
        nameLabel?.text = movie.title
        releaseDateLabel?.text = formatter.string(from: movie.releaseDate ?? Date())
        thumbnailImageView?.setImage(with: movie.imageURL)
        return self
    }
}
