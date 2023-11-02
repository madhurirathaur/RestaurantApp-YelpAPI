//
//  RestaurantPhotosVC.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 28/10/23.
//

import Foundation
import UIKit



class RestaurantPhotosVC: UICollectionViewController {
    private let reuseIdentifier = "photocell"
    var photos = [String]()
   
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        guard let url = NSURL(string: photos[indexPath.row]) else { return UICollectionViewCell() }
        ImageCache.shared.load(url: url, completion: { photo in
            DispatchQueue.main.async {
                cell.imageView.image = photo
            }
        })
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = sender as? IndexPath,
                  let photoViewer = segue.destination as? PhotoViewerVC, let url = NSURL(string: photos[indexPath.item]) else { return }
            collectionView.deselectItem(at: indexPath, animated: false)
            photoViewer.photoUrl = url
        }
    }
}


extension RestaurantPhotosVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width  = (view.frame.width - 30) / 3
        return CGSize(width: width, height: width)
    }
}
