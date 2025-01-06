//
//  UIImageView+Extension.swift
//  Live It
//
//  Created by Muniyaraj on 04/09/24.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCacheWithURL(_ urlString: String) {
        
        self.image = nil
        
        // already exists image
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        // fetch from url
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if error != nil && data == nil {
                    print("Unable to fetch image from URL")
                    return
                }
                
                guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.image = downloadedImage
                    imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                }
            }
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
