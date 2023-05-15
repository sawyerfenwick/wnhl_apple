//
//  PlayerID.swift
//  WNHL-App
//
//  Created by Sawyer Fenwick on 2021-09-08.
//

import Foundation

/**
 Defines a PlayerID Object
 */
struct PlayerID: Decodable {
    let data: [String: Names]
    
    enum CodingKeys: String, CodingKey {
        case data
    }//CodingKeys
    
    struct Names: Decodable {
        let name: String

        enum CodingKeys: String, CodingKey {
            case name
        }//CodingKeys
    }//Names
}//PlayerID
