//
//  ViewController.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import UIKit

class RestaurantListVC: UIViewController {
    @IBOutlet var tableView: UITableView!
   
    
    // MARK: Stored Properties
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    private var searchTerm = ""
    private let waitIndicator = ProgressIndicator()
    lazy var viewModel = {
        RestaurantListVM()
    }()

    //TODO: dummyCoordinate to be replaced with user's current location <CoreLocation>
    let dummyCoordinate: (latitude: Double, longitude: Double) = (43.64, -79.37)
    private var restaurantList = [RestaurantModel]() {
        didSet {
            if !self.restaurantList.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        serUpSearchBar()
        fetchRestaurant()
    }

    // MARK: Helpers
    func serUpSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants.."
        navigationItem.titleView = searchBar
    }
    
    func fetchRestaurant() {
        waitIndicator.showActivityIndicator(uiView: view)
        viewModel.fetchRestaurantList(coordinates: dummyCoordinate) { [weak self] list, error in
            guard let self = self else  { return }
            self.restaurantList = list
            self.waitIndicator.hideActivityIndicator()
        }
    }
    
    // MARK: Action
    @IBAction func sortAction(_ sender: UIBarButtonItem) {
        let optionMenuController = UIAlertController(title: nil, message: "Sort By", preferredStyle: .actionSheet)
        optionMenuController.popoverPresentationController?.barButtonItem = sender
        for sortBy in YelpSortMode.allCases {
          let action = UIAlertAction(title: sortBy.description, style: .default) { action in
              self.waitIndicator.showActivityIndicator(uiView: self.view)
            
              self.viewModel.fetchRestaurantList(self.searchTerm, sortBy: YelpSortMode(rawValue: sortBy.rawValue) ?? .best_match, coordinates: self.dummyCoordinate) { [weak self] list, error in
                
                  guard let self = self else  { return }
                  self.restaurantList = list
                  self.waitIndicator.hideActivityIndicator()
                  
              }
            }
            optionMenuController.addAction(action)
        }
      
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenuController.addAction(cancelAction)
        present(optionMenuController, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "RestaurantDetailsVC") {
            guard let vc = segue.destination as? RestaurantDetailsVC, let indexPath = sender as? IndexPath else { return }
            vc.restaurantId = restaurantList[indexPath.row].id
        }
    }
    
}



// MARK: Tableview Methods delegate/data source
extension RestaurantListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell") as? RestaurantListCell else { return UITableViewCell() }
        cell.restaurantObject = restaurantList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "RestaurantDetailsVC", sender: indexPath)
    }
}


// MARK: - UISearchBar delegate

extension RestaurantListVC: UISearchBarDelegate {
  
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
         true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
         true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        guard !searchTerm.isEmpty else  { return }
        waitIndicator.showActivityIndicator(uiView: view)
        viewModel.fetchRestaurantList(searchTerm, coordinates: dummyCoordinate){ [weak self] list, error in
            guard let self = self else  { return }
            self.restaurantList = list
            waitIndicator.hideActivityIndicator()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchBar.resignFirstResponder()
    }
}
