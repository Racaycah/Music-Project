//
//  LikedSong+CoreDataProperties.swift
//  Music-Project
//
//  Created by Ata Doruk on 18.01.2021.
//
//

import Foundation
import CoreData


extension LikedSong {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<LikedSong> {
        return NSFetchRequest<LikedSong>(entityName: "LikedSong")
    }

    @NSManaged public var ids: Set<Int>?

}

extension LikedSong : Identifiable {

}
