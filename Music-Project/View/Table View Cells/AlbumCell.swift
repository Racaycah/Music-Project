//
//  AlbumCell.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumCoverImageView: AsyncImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    private var album: Album! {
        didSet {
            albumNameLabel.text = album.name
            releaseDateLabel.text = album.releaseDateString
            
            if let imageUrl = album.imageUrl60 {
                albumCoverImageView.loadImage(from: imageUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        albumNameLabel.numberOfLines = 2
        albumNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumCoverImageView.cancelDownload()
    }
    
    func configure(with album: Album) {
        self.album = album
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
