//
//  TrackCell.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

class TrackCell: UICollectionViewCell {
    
    @IBOutlet weak var albumArtworkImageView: AsyncImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    static let reuseIdentifier = "TrackCell"
    static let nibName = "TrackCell"
    
    private var track: Track! {
        didSet {
            albumNameLabel.text = track.name
            
            if let image100Url = track.artworkUrl100 {
                albumArtworkImageView.loadImage(from: image100Url)
            } else if let image60Url = track.artworkUrl60 {
                albumArtworkImageView.loadImage(from: image60Url)
            } else {
                albumArtworkImageView.image = UIImage(systemName: "play")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .secondarySystemBackground
        
        albumNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        albumNameLabel.numberOfLines = 0
        
        albumArtworkImageView.layer.cornerRadius = 10
        albumArtworkImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configure(with track: Track) {
        self.track = track
    }

}
