//
//  PhotoViewerVC.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 28/10/23.
//

import UIKit

class PhotoViewerVC : UIViewController {
    @IBOutlet var restaurantImageView : UIImageView!
    private let waitIndicator = ProgressIndicator()

    var photoUrl: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImage()
    }
    
    private func setUpImage() {
        guard let url = photoUrl else { return }
        waitIndicator.showActivityIndicator(uiView: view)
        ImageCache.shared.load(url: url, completion: { [weak self] photo in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.restaurantImageView.image = photo
                self.waitIndicator.hideActivityIndicator()
            }
        })
    }
}
