//
//  RestaurantListCell.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import UIKit

class RestaurantListCell: UITableViewCell {
    //MARK: outlets
    @IBOutlet fileprivate var distanceLabel: UILabel!
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var listingImageView: UIImageView!
    @IBOutlet fileprivate var ratingImageView: StarsView!
    @IBOutlet fileprivate var reviewsLabel: UILabel!
    @IBOutlet fileprivate var addressLabel: UILabel!
    
    //MARK: cell setup
    var restaurantObject: RestaurantModel? {
        didSet {
             self.distanceLabel.text = String(format: "%.2f mi", restaurantObject?.distance ?? 0)
            self.nameLabel.text = restaurantObject?.name
            self.reviewsLabel.text = "\(restaurantObject?.review_count ?? 0) reviews"
            
            if let restaurantObjectImageURL = restaurantObject?.image_url, let url =  NSURL(string: restaurantObjectImageURL) {
                ImageCache.shared.load(url: url, completion: { image in
                    DispatchQueue.main.async {
                        self.listingImageView.image = image
                    }
                })
            } else {
                self.listingImageView.image = UIImage(named: "placeHolder")
            }
            addressLabel.text = restaurantObject?.location.display_address.joined(separator: ", ")
            
            if let rating = restaurantObject?.rating {
                self.ratingImageView.rating = rating
            }
        }
    }
}
