//
//  Players.swift
//  alamoTest
//
//  Created by Sawyer Fenwick on 2021-09-04.
//

import Foundation

/**
 Defines a Player Object
 */
struct Players: Decodable {
    var name: [String: String]?
    var id: Int?
    var media: Int?
    var leagues: [Int]?
    var seasons: [Int]?
    var number: Int?
    var team: [Int]?
    var content: Content?
    var statistics: Statistic?
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case leagues
        case seasons
        case number
        case statistics
        case name = "title"
        case media = "featured_media"
        case team = "current_teams"
    }//CodingKeys
    
    struct Content: Decodable {
        var rendered: String?
        
        enum CodingKeys: String, CodingKey {
            case rendered
        }
    }//Content
    
    struct Statistic: Decodable {
        var three: [String: Statistics]?
        
        enum CodingKeys: String, CodingKey {
            case three = "3"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do{
                three = try container.decode([String: Statistics].self, forKey: .three)
            }
            catch {
                three = nil
            }
        }//init
    }//Statistic
    
    struct Statistics: Decodable {
        var name: String?
        var team: String?
        var p: String?
        var a: Int?
        var g: Int?
        var gp: String?
        var spercent: Int?
        var svpercent: Int?
        
        enum CodingKeys: String, CodingKey {
            case name
            case team
            case p
            case a
            case g
            case gp
            case spercent
            case svpercent
        }//CodingKeys
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            gp = try container.decode(String.self, forKey: .gp)
            p = try container.decode(String.self, forKey: .p)
            name = try container.decode(String.self, forKey: .name)
            team = try container.decode(String.self, forKey: .team)
            do {
                spercent = try container.decode(Int.self, forKey: .spercent)
            } catch DecodingError.typeMismatch {
                spercent = try Int(container.decode(String.self, forKey: .spercent))
            }
            do {
                svpercent = try container.decode(Int.self, forKey: .svpercent)
            } catch DecodingError.typeMismatch {
                svpercent = try Int(container.decode(String.self, forKey: .svpercent))
            }
            do {
                g = try container.decode(Int.self, forKey: .g)
            } catch DecodingError.typeMismatch {
                g = try Int(container.decode(String.self, forKey: .g))
            }
            do {
                a = try container.decode(Int.self, forKey: .a)
            } catch DecodingError.typeMismatch {
                a = try Int(container.decode(String.self, forKey: .a))
            }
        }//init
    }//Statistics
}//Players
