//
//  YelpClient.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import Foundation

//Yelp API key other details
let yelpApiKey = "QNKER8TyqsfWZwJp_iZ_Y344awHodxDtsUC0vd9F7WpST94dcQLvhUho10y-70d5waw2O0R_2gHObZZQQG755EgWCBpdjY8vIuHhTC-oYTYraTFMB5VnWDLuoxw3ZXYx"
let yelpBaseURL = "https://api.yelp.com/v3"
let yelpSearchLimit = 10

enum YelpSortMode: String, CustomStringConvertible, CaseIterable {
    case best_match, distance, rating, review_count
   
    var description: String {
        switch self {
        case .best_match:
            return "Best Matched"
        case .distance:
            return "Distance"
        case .rating:
            return "Highest Rated"
        case .review_count:
            return "Review Count"
        }
    }
}

protocol NetworkRequestor {
    var urlString : String { get }
    var request: URLRequest? { get }
}

enum YelpBusinessAPI : NetworkRequestor {
    case search(coordinate: (latitude: Double, longitude: Double), term: String?, sortBy: YelpSortMode = .best_match, limit: Int = 10, category: String = "Restaurant")
    case searchDetail(Id: String)
    
    var urlString : String {
        switch self {
        case .search( _ , _ , _ , _ , _ ):
           return yelpBaseURL + "/businesses/search"
        case .searchDetail( _ ):
           return yelpBaseURL + "/businesses/"
        }
    }
    
    var request: URLRequest? {
        var urlParams = ""
        switch self {
        case .search(let coordinate ,let term, let sortBy,let limit ,let category):
            urlParams = "?latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy.rawValue)"
            if let term = term, !term.isEmpty {
                urlParams += "&term=\(term)"
            }
        case .searchDetail(let Id):
            urlParams = Id
        }
        let completeURLString = urlString + urlParams
        guard let url = URL(string: completeURLString) else { return nil}
        debugPrint("URL requested: \(completeURLString)")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(yelpApiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}

