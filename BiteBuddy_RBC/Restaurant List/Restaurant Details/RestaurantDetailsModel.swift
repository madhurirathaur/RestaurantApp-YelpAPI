//
//  RestaurantModel.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 28/10/23.
//

import Foundation


struct RestaurantDetailsModel: Decodable {
    var name : String
    var image_url : String?
    var rating : Double = 0.0
    var categories : [Categories]
    var review_count : Int = 0
    var location: Location
    var coordinates: Coordinates?
    var photos : [String]
    var display_phone : String?
    var is_closed : Bool?
}

struct Categories: Decodable
{
    var title : String
}

struct Coordinates: Decodable
{
    var latitude : Double?
    var longitude : Double?
}
