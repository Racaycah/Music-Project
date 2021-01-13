//
//  ArtistSearch.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import Foundation

struct ArtistSearch: Decodable, Equatable {
    let name: String
    let genre: String?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "artistName"
        case genre = "primaryGenreName"
        case id = "artistId"
    }
}

extension ArtistSearch: CustomStringConvertible {
    var description: String {
        "Name: \(name)\tGenre: \(genre ?? "")\n"
    }
}
