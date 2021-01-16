//
//  AlbumsViewModel.swift
//  Music-Project
//
//  Created by Ata Doruk on 15.01.2021.
//

import UIKit

class AlbumsViewModel {
    var albums = [Album]()
    
    var canSearchForMore: Bool {
        albums.isEmpty || albums.count % 20 == 0
    }
    
    func getAlbums(artistId: Int, completion: @escaping (([Album]) -> Void)) {
        guard canSearchForMore else { return }
        
        NetworkManager.shared.request(.albums(artistId: artistId, limit: min(albums.count + 20, 200)), decodingTo: [Album].self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var fetchedAlbums):
                // First result is the artist, remove it
                fetchedAlbums.removeFirst()
                
                self.albums.append(contentsOf: self.albums.isEmpty ? fetchedAlbums : fetchedAlbums.filter { !self.albums.contains($0) })
                
                completion(self.albums)
            case .failure(let error):
                print("Album fetch error: \(error.localizedDescription)")
                print(error)
            }
        }
    }
}
