//
//  MediaURL.swift
//  WNHL-App
//
//  Created by sawyer on 2021-09-13.
//

import Foundation

struct MediaURL: Decodable {
    let url: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case url = "guid"
    }
}
