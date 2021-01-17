//
//  LoadingCollectionViewCell.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "LoadingCollectionViewCell"
    static let nibName = "LoadingCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
    }

}
