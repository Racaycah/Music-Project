//
//  TracksViewModel.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

class TracksViewModel {
    var tracks = [Track]()
    
    var canLoadMore = true
    
    func getTracks(albumId: Int, completion: @escaping (([Track]) -> Void)) {
        guard canLoadMore else { return }
        
        if !tracks.isEmpty && tracks.count % 20 != 0 {
            canLoadMore = false
            completion(tracks)
            return
        }
        
        NetworkManager.shared.request(.tracks(albumId: albumId, limit: min(tracks.count + 20, 200)), decodingTo: [Track].self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(var fetchedTracks):
                // First result is the album as a Track object with all nil values, remove it
                fetchedTracks.removeFirst()
                
                if fetchedTracks.isEmpty || fetchedTracks.count == self.tracks.count {
                    self.canLoadMore = false
                    completion(self.tracks)
                    return
                }
                
                self.canLoadMore = true
                
                self.tracks.append(contentsOf: self.tracks.isEmpty ? fetchedTracks : fetchedTracks.filter { !self.tracks.contains($0) })
                print("Tracks count: \(self.tracks.count)")
                completion(self.tracks)
            case .failure(let error):
                print("Track fetch error: \(error.localizedDescription)")
                print(error)
            }
        }
    }
}
