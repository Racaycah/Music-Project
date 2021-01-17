//
//  AlbumTracksViewController.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

class AlbumTracksViewController: UIViewController {
    
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    
    var album: Album!
    
    private let tracksViewModel = TracksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = album.name
        
        tracksCollectionView.delegate = self
        tracksCollectionView.dataSource = self
        
        tracksCollectionView.register(UINib(nibName: TrackCell.nibName, bundle: nil), forCellWithReuseIdentifier: TrackCell.reuseIdentifier)
        tracksCollectionView.register(UINib(nibName: LoadingCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier)
        
        tracksCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func loadTracks() {
        tracksViewModel.getTracks(albumId: album.id!) { [unowned self] (tracks) in
            DispatchQueue.main.async {
                self.tracksCollectionView.reloadData()
            }
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumTracksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let phoneWidth = UIScreen.main.bounds.size.width
        
        let heightPadding: CGFloat = 100
        let numberOfTracksPerRow: CGFloat = 3
        
        let width = ((phoneWidth - 8 - 16) / numberOfTracksPerRow) - 8
        
        return CGSize(width: width, height: width + heightPadding)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if tracksViewModel.canLoadMore && indexPath.row == tracksViewModel.tracks.count {
            loadTracks()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AlbumTracksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tracksViewModel.tracks.count + (tracksViewModel.canLoadMore ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tracksViewModel.canLoadMore && indexPath.row == tracksViewModel.tracks.count {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseIdentifier, for: indexPath) as! LoadingCollectionViewCell
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }
        
        let trackCell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.reuseIdentifier, for: indexPath) as! TrackCell
        
        let track = tracksViewModel.tracks[indexPath.row]
        
        trackCell.configure(with: track)
        
        return trackCell
    }
    
    
}
