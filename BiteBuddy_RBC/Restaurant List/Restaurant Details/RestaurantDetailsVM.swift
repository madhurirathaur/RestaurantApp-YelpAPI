//
//  RestaurantDetailsVM.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 28/10/23.
//

import Foundation

enum RestaurantOpenCloseStatus : String {
    case open = "Open"
    case close = "Closed"
}

class RestaurantDetailsVM {

    /**
     Fetches restaurant Details
     
     - parameter id: String - restaurant's Id
     - returns: RestaurantDetailsModel list and error optional object.
     
     */
    
    func fetchRestaurantDetails(_ id: String, completion: @escaping (RestaurantDetailsModel?, Error?) -> Void) {
        
        let requestObject = YelpBusinessAPI.searchDetail(Id: id)
        
        NetworkManager.shared.sendRequest(expectedTypeObject: RestaurantDetailsModel.self, requestObject) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let list):
                completion(list, nil)
            }
        }
    }
    
}
