//
//  ImageCache.swift
//  Music-Project
//
//  Created by Ata Doruk on 16.01.2021.
//

import UIKit

class ImageCache {
    private static let cache = NSCache<AnyObject, AnyObject>()
    
    static func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as AnyObject) as? UIImage
    }
    
    static func save(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as AnyObject)
    }
}
