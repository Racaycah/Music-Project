//
//  UIImageView+AsyncImageLoad.swift
//  Music-Project
//
//  Created by Ata Doruk on 16.01.2021.
//

import UIKit

class AsyncImageView: UIImageView {
    private var imageLoadTask: URLSessionDataTask!
    private var spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL) {
        image = nil
        
        addSpinner()
        
        if let imageTask = imageLoadTask {
            imageTask.cancel()
        }
        
        if let cachedImage = ImageCache.image(for: url) {
            image = cachedImage
            removeSpinner()
            return
        }
        
        imageLoadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let fetchedImage = UIImage(data: data) else {
                print("Couldn't load image for url: \(url)")
                return
            }
            
            ImageCache.save(image: fetchedImage, for: url)
            
            DispatchQueue.main.async {
                self.image = fetchedImage
                self.removeSpinner()
            }
        }
        
        imageLoadTask.resume()
    }
    
    func cancelDownload()  {
        if let task = imageLoadTask {
            task.cancel()
        }
    }
    
    private func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        spinner.startAnimating()
    }
    
    private func removeSpinner() {
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
