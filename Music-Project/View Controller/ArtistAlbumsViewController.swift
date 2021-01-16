//
//  ArtistAlbumsViewController.swift
//  Music-Project
//
//  Created by Ata Doruk on 15.01.2021.
//

import UIKit

class ArtistAlbumsViewController: UIViewController {
    
    @IBOutlet weak var albumsTableView: UITableView!
    
    var artist: ArtistSearch!
    
    private let albumsViewModel = AlbumsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = artist.name
        
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
        
        albumsTableView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellReuseIdentifier: "AlbumCell")
        
        albumsViewModel.getAlbums(artistId: artist.id) { [unowned self] (albums) in
            DispatchQueue.main.async {
                self.albumsTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ArtistAlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension ArtistAlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albumsViewModel.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let albumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        let album = albumsViewModel.albums[indexPath.row]
        
        albumCell.configure(with: album)
        
        return albumCell
    }
    
}
