//
//  ArtistSearchViewModel.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import Foundation

class ArtistSearchViewModel {
    var artists = [ArtistSearch]()
    
    var lastSearched = ""
    var limitReached = false
    
    func canSearchForMore(name: String) -> Bool {
        if name != lastSearched {
            artists.removeAll()
            limitReached = false
            return true
        }
        
        if artists.isEmpty { return true }
        
        return artists.count % 20 == 0
    }
    
    func searchArtists(withName name: String, completion: @escaping (([ArtistSearch]) -> Void)) {
        guard canSearchForMore(name: name) else { return }
        
        let limit = lastSearched == name ? min(artists.count + 20, 200) : 20
        
        NetworkManager.shared.request(.search(artist: name, limit: limit), decodingTo: [ArtistSearch].self) { [weak self] (result) in
            guard let self = self else { return }
            
            self.lastSearched = name
            
            switch result {
            case .success(let fetchedArtists):
                if fetchedArtists.count == self.artists.count {
                    self.limitReached = true
                    completion(self.artists)
                } else {
                    self.artists.append(contentsOf: self.artists.isEmpty ? fetchedArtists : fetchedArtists.filter { !self.artists.contains($0) })
                    completion(self.artists)
                }
            case .failure(let error):
                print("Artist search error: \(error.localizedDescription)")
                return
            }
        }
    }
}
