//
//  Standings.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-06.
//

import Foundation

/**
 Defines a Standings Object
 */
struct Standings: Decodable {
    let id: Int
    let title: [String: String]?
    let data: [String: StandingData]?
    let seasons: [Int]
    
    enum CodingKeys: String, CodingKey{
        case id
        case data
        case seasons
        case title
    }//CodingKeys
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        seasons = try container.decode([Int].self, forKey: .seasons)
        title = try container.decode([String: String].self, forKey: .title)
        do{
            data = try container.decode([String: StandingData].self, forKey: .data)
        }
        catch {
            data = nil
        }
    }//init
    
    struct StandingData: Decodable {
        let pos: String
        let name: String
        let gp: String
        let w: String
        let l: String
        let ties: String
        let pts: String
        let gf: String
        let ga: String
                
        enum CodingKeys: String, CodingKey{
            case name
            case gp
            case w
            case l
            case ties
            case pts
            case gf
            case ga
            case pos
        }//CodingKeys
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            gp = try container.decode(String.self, forKey: .gp)
            w = try container.decode(String.self, forKey: .w)
            l = try container.decode(String.self, forKey: .l)
            ties = try container.decode(String.self, forKey: .ties)
            pts = try container.decode(String.self, forKey: .pts)
            gf = try container.decode(String.self, forKey: .gf)
            ga = try container.decode(String.self, forKey: .ga)
            name = try container.decode(String.self, forKey: .name)
            do {
                pos = try String(container.decode(Int.self, forKey: .pos))
            } catch DecodingError.typeMismatch {
                pos = try container.decode(String.self, forKey: .pos)
            }
        }//init
    }//StandingsData
}//Standings

