//
//  Album.swift
//  Music-Project
//
//  Created by Ata Doruk on 15.01.2021.
//

import Foundation

struct Album: Decodable, Equatable {
    let id: Int?
    let name: String?
    let imageUrl60: URL?
    let imageUrl100: URL?
    private let releaseDate: Date?
    var releaseDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let date = releaseDate else { return "" }
        
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "collectionId"
        case name = "collectionName"
        case imageUrl60 = "artworkUrl60"
        case imageUrl100 = "artworkUrl100"
        case releaseDate
    }
}
