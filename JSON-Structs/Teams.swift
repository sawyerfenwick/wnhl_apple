//
//  Teams.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-04.
//

import Foundation

/**
 Defines a Team Object 
 */
struct Teams: Decodable {
    var name: [String: String]?
    var seasonIDs: [Int]?
    var id: Int?
    var slug: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case id = "id"
        case slug = "slug"
        case seasonIDs = "seasons"
    }//CodingKeys
}//Teams

