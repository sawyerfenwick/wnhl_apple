//
//  Game.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-05.
//

import Foundation

/**
 Defines a Game Object
 */
struct Game: Decodable {
    
    let id: Int
    let date: String
    let title: [String: String]
    let seasons: [Int]
    let venues: [Int]
    let teams: [Int]
    let results: [String]
  
  enum CodingKeys: String, CodingKey {
    case id
    case date
    case title
    case seasons
    case venues
    case teams
    case results = "main_results"
  }//CodingKeys
}//Game
