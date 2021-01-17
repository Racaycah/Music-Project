//
//  AlbumsViewModel.swift
//  Music-Project
//
//  Created by Ata Doruk on 15.01.2021.
//

import UIKit

class AlbumsViewModel {
    var albums = [Album]()
    
    var canLoadMore = true
    
    func getAlbums(artistId: Int, completion: @escaping (([Album]) -> Void)) {
        guard canLoadMore else { return }
        
        if !albums.isEmpty && albums.count % 20 != 0 {
            canLoadMore = false
            completion(albums)
            return
        }
        
        NetworkManager.shared.request(.albums(artistId: artistId, limit: min(albums.count + 20, 200)), decodingTo: [Album].self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var fetchedAlbums):
                // First result is the artist as an Album object with all nil values, remove it
                fetchedAlbums.removeFirst()
                
                if fetchedAlbums.isEmpty || fetchedAlbums.count == self.albums.count {
                    self.canLoadMore = false
                    completion(self.albums)
                    return
                }
                
                self.canLoadMore = true
                
                self.albums.append(contentsOf: self.albums.isEmpty ? fetchedAlbums : fetchedAlbums.filter { !self.albums.contains($0) })
                print("Albums count: \(self.albums.count)")
                completion(self.albums)
            case .failure(let error):
                print("Album fetch error: \(error.localizedDescription)")
                print(error)
            }
        }
    }
}
