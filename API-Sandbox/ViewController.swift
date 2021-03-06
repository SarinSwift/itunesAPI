//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        exerciseOne()
        exerciseTwo()
        exerciseThree()
        
        callTopMovies()
    }
    
    func callTopMovies() {
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let jsonData = json["feed"]["entry"]
                    let random = Int(arc4random_uniform(UInt32(jsonData.count)))
                    let movieData = jsonData[random]
                    
                    self.movie = Movie(json: movieData)
                    
                    self.movieTitleLabel.text = self.movie.name
                    self.rightsOwnerLabel.text = self.movie.rightsOwner
                    self.releaseDateLabel.text = self.movie.releaseDate
                    self.priceLabel.text = String(self.movie.price)
                    self.posterImageView.af_setImage(withURL: URL(string: self.movie.poster)!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: movie.link)!)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // grab random movies
        callTopMovies()
    }
}

