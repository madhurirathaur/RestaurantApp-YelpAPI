//
//  RestaurantModel.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 26/10/23.
//

import Foundation

//MARK: Models

struct BusinessModel: Decodable {
    var businesses : [RestaurantModel]
}

struct RestaurantModel: Decodable {
    var id: String
    var name : String
    var image_url : String?
    var rating : Double
    var distance : Double
    var review_count : Int?
    var location: Location
}

struct Location: Decodable
{
    var display_address : [String]
}
