//
//  ViewController.swift
//  MovieViewer
//
//  Created by builes on 20/07/21.
//

import UIKit

class MovieListTVC: UITableViewController {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    private let releaseDateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var movies:[Movie] = []
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Movies"
        fetchMovies()
    }

    private func fetchMovies() {
        configureActivityIndicator()
        MovieDBHTTPClient().GETMovies(for: "thingy") { movies, error in
            self.activityIndicator.stopAnimating()
            
            if let moviesFetched = movies, error == nil {
                self.movies = moviesFetched
                self.tableView.reloadData()
            } else {
                print("Not diplaying any movies, an unexpected error ocurred")
                // TODO: Mosve to a general alerts utilities class
                let alertController = UIAlertController(title: "Unexpected Error",
                                                        message: "We were unable to fetch the movies. Please try again later.",
                                                        preferredStyle: .alert)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Custom UI code
    private func configureActivityIndicator() {
        tableView.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCellID", for: indexPath)
        
        if let movieCell = cell as? MovieCell {
            return movieCell.configure(with: movies[indexPath.row],formatter: releaseDateFormatter)
        }

        return cell
    }
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let movieDetailsVC = storyBoard.instantiateViewController(identifier: "MovieDetailsVC") { coder in
            return MovieDetailsVC(coder: coder, theMovie: self.movies[indexPath.row])
        }
        
        navigationController?.pushViewController(movieDetailsVC, animated: true)
    }
}
