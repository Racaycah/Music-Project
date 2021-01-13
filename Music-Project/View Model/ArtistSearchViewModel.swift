//
//  ArtistSearchViewModel.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import Foundation

class ArtistSearchViewModel {
    var artists = [ArtistSearch]()
    
    var canSearchForMore: Bool {
        artists.isEmpty || artists.count % 20 == 0
    }
    
    func searchArtists(withName name: String, completion: @escaping (([ArtistSearch]) -> Void)) {
        guard canSearchForMore else { return }
        
        NetworkManager.shared.request(.search(artist: name, limit: min(artists.count + 20, 200)), decodingTo: [ArtistSearch].self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.artists.append(contentsOf: self.artists.isEmpty ? response.results : response.results.filter { !self.artists.contains($0) })
                completion(self.artists)
            case .failure:
                return
            }
        }
    }
}
