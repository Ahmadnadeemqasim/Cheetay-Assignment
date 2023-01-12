//
//  MovieCell.swift
//  Assignment
//
//  Created by Ahmad Qasim  on 1/5/23.
//

import UIKit

protocol MovieDelegate{
    func btnFavouritClicked(sender: UIButton)
}

class MovieCell: UICollectionViewCell {

    var delegate: MovieDelegate?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var btnFavourite: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true

    }
    @IBAction func btnFavouritTapped(_ sender: UIButton) {
        if delegate != nil {
            delegate?.btnFavouritClicked(sender: sender)
        }
    }
    
}
