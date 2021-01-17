//
//  TrackDetailViewController.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit
import AVKit
import CoreData

class TrackDetailViewController: AVPlayerViewController {
    
    var track: Track!
    
    var isSongLiked: Bool {
        likeButton.image == UIImage(systemName: "heart.fill")
    }
    
    private let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeSong))
    private let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareSong))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = track.name
        
        if let likedSongs = getLikedSongs(), likedSongs.contains(track.id!) {
            likeButton.image = UIImage(systemName: "heart.fill")
        }
        
        navigationItem.setRightBarButtonItems([shareButton, likeButton], animated: true)
        
        if let previewUrl = track.previewUrl {
            player = AVPlayer(url: previewUrl)
            player?.play()
        }
    }
    
    func getLikedSongs() -> Set<Int>? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let likedSongsRequest = LikedSong.createFetchRequest()
        
        let likedSong = try? context.fetch(likedSongsRequest).first
        
        return likedSong?.ids
    }
    
    @objc
    private func likeSong() {
        if isSongLiked {
            removeLike()
        } else {
            like()
        }
        
    }
    
    private func like() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let likedSongsRequest = LikedSong.createFetchRequest()
        
        let likedSong = try? context.fetch(likedSongsRequest).first
        likedSong?.ids?.insert(track.id!)
        
        appDelegate.saveContext()
        
        likeButton.image = UIImage(systemName: "heart.fill")
    }
    
    private func removeLike() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let likedSongsRequest = LikedSong.createFetchRequest()
        
        let likedSong = try? context.fetch(likedSongsRequest).first
        likedSong?.ids?.remove(track.id!)
        
        appDelegate.saveContext()
        
        likeButton.image = UIImage(systemName: "heart")
    }
    
    @objc
    private func shareSong() {
        let actionSheet = UIAlertController(title: "Which one do you want to share?", message: nil, preferredStyle: .actionSheet)
        let songAction = UIAlertAction(title: "Share Song", style: .default) { [unowned self] (_) in
            var shareItems: [Any] = ["Listen to \(track.name!) by \(track.artistName!) in iTunes!"]
            if let viewUrl = track.trackViewUrl {
                shareItems.append(viewUrl)
            }
            
            shareItems.append(ImageCache.image(for: track.artworkUrl100 ?? track.artworkUrl60!) as Any)
            
            let ac = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            self.present(ac, animated: true)
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(songAction)
        
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}
