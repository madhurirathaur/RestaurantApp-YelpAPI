//
//  RestaurantDetailsVC.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import UIKit
import MapKit

class RestaurantDetailsVC: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var ratingImageView: StarsView!
    @IBOutlet fileprivate var categoriesLabel: UILabel!
    @IBOutlet fileprivate var numReviewsLabel: UILabel!
    @IBOutlet fileprivate var isClosedLabel: UILabel!
    @IBOutlet fileprivate var restaurantImageView: UIImageView!
    @IBOutlet fileprivate var mapView: MKMapView!
    @IBOutlet fileprivate var displayAddressLabel: UILabel!
    @IBOutlet fileprivate var displayPhoneLabel: UILabel!
    @IBOutlet fileprivate var photosBarButton: UIBarButtonItem!
    
    
    // MARK: Stored Properties
    private let waitIndicator = ProgressIndicator()

    lazy var viewModel = {
        RestaurantDetailsVM()
    }()

    
    private var restaurantObject: RestaurantDetailsModel? {
        didSet {
            DispatchQueue.main.async {
                self.setupViews()
            }
        }
    }
    var restaurantId: String = ""
    
    
    // MARK: Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        photosBarButton.isEnabled = false
        fetchRestaurantDetails()
    }

    // MARK: Helpers
    func fetchRestaurantDetails() {
        self.waitIndicator.showActivityIndicator(uiView: view)
        viewModel.fetchRestaurantDetails(restaurantId) { [weak self] details, error in
            self?.restaurantObject = details
            self?.waitIndicator.hideActivityIndicator()
        }
    }
    
    // MARK: view setup
    private func setupViews() {
        guard let restaurantObject = restaurantObject else { return }
        navigationItem.title = restaurantObject.name
        photosBarButton.isEnabled = !restaurantObject.photos.isEmpty
        func setupLabels() {
            nameLabel.text = restaurantObject.name
            self.numReviewsLabel.text = "\(restaurantObject.review_count) Reviews"
            self.categoriesLabel.text = restaurantObject.categories.map { $0 .title}.joined(separator: ", ")
            
            if let isClosed = restaurantObject.is_closed, isClosed {
                isClosedLabel.text = RestaurantOpenCloseStatus.close.rawValue
                isClosedLabel.textColor = .systemRed
            } else {
                isClosedLabel.text = RestaurantOpenCloseStatus.open.rawValue
                isClosedLabel.textColor = .systemGreen
            }
            displayAddressLabel.text = restaurantObject.location.display_address.joined(separator: ", ")
            if let display_phone = restaurantObject.display_phone {
                displayPhoneLabel.text = display_phone.isEmpty ? "No Contacts" : display_phone
            }
        }
        
        func setupImageViews() {
            self.ratingImageView.rating = restaurantObject.rating
            
            if let imageURL = restaurantObject.image_url, let url =  NSURL(string: imageURL) {
                ImageCache.shared.load(url: url, completion: { [weak self] image in
                    DispatchQueue.main.async {
                        self?.restaurantImageView.image = image
                    }
                })
            }
        }
        
        func setupAnnotation() {
            if let coordinate = restaurantObject.coordinates, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                
                mapView.addAnnotation(annotation)
                mapView.showAnnotations([annotation], animated: true)
            }
            
        }
        setupLabels()
        setupImageViews()
        setupAnnotation()
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "photos") {
            guard let vc = segue.destination as? RestaurantPhotosVC, let restaurantObject = restaurantObject else { return }
            vc.photos = restaurantObject.photos
        }
    }
    
    // MARK: tableview delegate
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  section == 0 ? 10.0 : 30.0
    }
}
