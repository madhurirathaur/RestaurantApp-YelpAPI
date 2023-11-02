//
//  ProgressIndicator.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 29/10/23.
//
import UIKit

class ProgressIndicator {
    private var container = UIView()
    private var loadingView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    
    init() { setup() }

    //Prepare ProgressIndicator view
    private func setup() {
        DispatchQueue.main.async {
            self.container.frame = UIScreen.main.bounds
            self.container.backgroundColor = .black.withAlphaComponent(0.4)
            
            self.loadingView.frame = CGRectMake(0, 0, 80, 80)
            self.loadingView.center = self.container.center
            self.loadingView.backgroundColor = .gray
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
            self.activityIndicator.style = .large
            self.activityIndicator.color = .white
            self.activityIndicator.center = CGPointMake(self.loadingView.frame.size.width / 2, self.loadingView.frame.size.height / 2)
            
            self.loadingView.addSubview(self.activityIndicator)
            self.container.addSubview(self.loadingView)
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        DispatchQueue.main.async {
            uiView.addSubview(self.container)
            self.activityIndicator.startAnimating()
        }
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.container.removeFromSuperview()
        }
    }
}
