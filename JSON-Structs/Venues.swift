//
//  Country.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-04.
//

import Foundation

/**
 Defines a Venue Object
 */
struct Venues: Decodable {
    var name: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }//CodingKeys
}//Venues
