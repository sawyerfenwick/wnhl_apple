//
//  SQLiteDatabase.swift
//  WNHL-App
//
//  Created by Sawyer Fenwick on 2021-09-07.
//

import Foundation
import SQLite

/**
 Creates the WNHL Database and its Tables: Games, Players, Seasons, Venues, Standings, and Teams
 */
class SQLiteDatabase {
    
    //Database path
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    //Table Column Names
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let slug = Expression<String>("slug")
    let seasonID = Expression<String>("seasonID")
    let title = Expression<String>("title")
    let home = Expression<Int64>("home")
    let away = Expression<Int64>("away")
    let homeScore = Expression<Int64?>("homeScore")
    let awayScore = Expression<Int64?>("awayScore")
    let date = Expression<String>("date")
    let time = Expression<String>("time")
    let location = Expression<Int64>("location")
    let mediaID = Expression<Int64>("mediaID")
    let mediaURL = Expression<String?>("mediaURL")
    let content = Expression<String>("content")
    let number = Expression<Int64>("number")
    let currTeam = Expression<Int64>("currTeam")
    let goals = Expression<Int64>("goals")
    let assists = Expression<Int64>("assists")
    let points = Expression<Int64>("points")
    let data = Expression<String>("data")
    let stats = Expression<String>("stats")
    let pos = Expression<String>("pos")
    let gp = Expression<String>("gp")
    let w = Expression<String>("w")
    let l = Expression<String>("l")
    let tie = Expression<String>("t")
    let pts = Expression<String>("pts")
    let gf = Expression<String>("gf")
    let ga = Expression<String>("ga")
    
    //Table Names
    let venues = Table("Venues")
    let seasons = Table("Seasons")
    let games = Table("Games")
    let teams = Table("Teams")
    let players = Table("Players")
    let standings = Table("Standings")
    
    init(){
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            
            //Delete tables if exists
            try db.run(venues.drop(ifExists: true))
            try db.run(seasons.drop(ifExists: true))
            try db.run(games.drop(ifExists: true))
            try db.run(teams.drop(ifExists: true))
            try db.run(players.drop(ifExists: true))
            try db.run(standings.drop(ifExists: true))
            
            //Create Venues Table
            try db.run(venues.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
            //Create Seasons Table
            try db.run(seasons.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
            //Create Games Table
            try db.run(games.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(home)
                t.column(away)
                t.column(homeScore)
                t.column(awayScore)
                t.column(date)
                t.column(time)
                t.column(location)
            })
            //Create Teams Table
            try db.run(teams.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(slug)
                t.column(seasonID)
            })
            //Create Players Table
            try db.run(players.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(content)
                t.column(seasonID)
                t.column(number)
                t.column(currTeam)
                t.column(goals)
                t.column(assists)
                t.column(points)
                t.column(gp)
                t.column(mediaID)
                t.column(mediaURL)
            })
            //Create Standings Table
            try db.run(standings.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(pos)
                t.column(name)
                t.column(gp)
                t.column(w)
                t.column(l)
                t.column(tie)
                t.column(pts)
                t.column(gf)
                t.column(ga)
            })
        }
        catch {
            print(error)
        }
    }//init
}//SQLiteDatabase
