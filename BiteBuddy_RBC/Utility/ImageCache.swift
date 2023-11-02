//
//  ImageCache.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 27/10/23.
//

import UIKit

public class ImageCache {
    public static let shared = ImageCache()
    private init() {}
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            completion(cachedImage)
            return
        }

        // Go fetch the image.
        URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            // Check for the error, then data and try to create the image.
            guard let responseData = data, let image = UIImage(data: responseData),
                  error == nil else {
                completion( nil)
                return
            }
            // Cache the image.
            self.cachedImages.setObject(image, forKey: url, cost: responseData.count)
            completion(image)
        }.resume()
    }
    
}
