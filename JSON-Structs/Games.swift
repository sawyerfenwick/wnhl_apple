//
//  Games.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-05.
//

import Foundation

/**
 Defines a Games Object
 */
struct Games: Decodable {
    let id: Int
    let data: [IDs]
    
  enum CodingKeys: String, CodingKey {
    case id
    case data
  }//CodingKeys
    
  struct IDs: Decodable {
    let ID: Int
        
    enum CodingKeys: String, CodingKey {
        case ID
    }//CodingKeys
  }//IDs
}//Games
