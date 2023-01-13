//
//  MovieDetailVC.swift
//  Assignment
//
//  Created by Devin Ellis  on 1/13/23.
//

import UIKit
import SDWebImage

class MovieDetailVC: UIViewController {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverView: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    var mvDetail : MovieDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let md = mvDetail {
            lblName.text = md.title
            lblDate.text = md.releaseDate
            lblOverView.text = md.overview
            let imagePath = C.BaseURL.imagPathURL + (md.posterPath)!
            let posterURL = URL(string: imagePath)
            imgPoster.sd_setImage(with: posterURL)
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    


}
