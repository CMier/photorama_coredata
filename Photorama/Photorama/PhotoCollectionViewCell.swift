//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by CSUFTitan on 5/4/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func update(with image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        update(with: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        update(with: nil)
    }

}
