//
//  Track.swift
//  Music-Project
//
//  Created by Ata Doruk on 17.01.2021.
//

import UIKit

struct Track: Decodable, Equatable {
    let id: Int?
    let name: String?
    let artistName: String?
    let artistViewUrl: URL?
    let collectionName: String?
    let collectionViewUrl: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let trackTimeMillis: Double?
    let isStreamable: Bool?
    let previewUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case name = "trackName"
        case artistName
        case artistViewUrl
        case collectionName
        case collectionViewUrl
        case artworkUrl60
        case artworkUrl100
        case trackTimeMillis
        case isStreamable
        case previewUrl
    }
}
