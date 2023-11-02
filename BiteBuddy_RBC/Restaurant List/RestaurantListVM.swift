//
//  RestaurantListVM.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import Foundation

class RestaurantListVM {
       /**
     Fetches restaurant list
    
    - parameter searchTerm: String - filter term for restaurants
    - parameter sortBy: YelpSortMode - mode to search
    - parameter coordinates: (Double, Double) - coordinates for the location to find
    - returns: RestaurantModel list and error optional object.
    
     */
    func fetchRestaurantList(_ searchTerm: String? = nil, sortBy: YelpSortMode = .best_match, coordinates: (Double, Double), completion: @escaping ([RestaurantModel], Error?) -> Void) {
      
        let requestObject = YelpBusinessAPI.search(coordinate: coordinates, term: searchTerm, sortBy: sortBy)
        
        NetworkManager.shared.sendRequest(expectedTypeObject: BusinessModel.self, requestObject) { result in
            switch result {
            case .failure(let error):
                completion([], error)
            case .success(let list):
                completion(list.businesses, nil)
            }
        }
    }
    
}
