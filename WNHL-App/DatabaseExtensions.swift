//
//  DatabaseExtensions.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-09-09.
//

import Foundation
import Swift
import UIKit
import SQLite

extension UITableViewController{
   
    
    /**
     Get the image string for the team's logo given the team's id.

     - Parameter teamId: The id of the team.

     - Returns: A string representing the image name for the logo from the assets.
     */
    func getImageNameFromTeamId(teamId:Int) -> String {
        // Each check of team name is case insensitive.
        if teamId == 940{
            return "steelers_logo"
        }
        else if teamId == 1370{
            return "townline_logo"
        }
        else if teamId == 1371{
            return "crownRoom_logo"
        }
        else if teamId == 1810{
            return "dusters_logo"
        }
        else if teamId == 1822{
            return "legends_logo"
        }
        else if teamId == 1824{
            return "islanders_logo"
        }
        // if there is no match for the team's logo, set it to be the WNHL Logo
        else{
            return "WNHL_Logo"
        }
    }
    
    /**
     Get the full name of the location given the id of the location from the database.

     - Parameter locationId: The id of the location.

     - Returns: A string representing the name of the location.
     */
    func getLocationNameFromId(locationId:Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            //Column Names
            //Table Column Names
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            //Table Names
            let venues = Table("Venues")
            // This is the more complex query
            // SELECT name WHERE id == locationId
            for venue in try db.prepare(venues.select(name).filter(id == locationId)){
                return ("\(venue[name])")
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
   
    /**
     Get the string form of the date object of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The full date object as a string.
     */
    func getGameDateString(gameId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let date = Expression<String>("date")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(date).filter(id == gameId)){
                return game[date]
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the string form of the time from the date object of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The time part of the Date object as a string.
     */
    func getGameTimeString(gameId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let time = Expression<String>("time")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(time).filter(id == gameId)){
                return game[time]
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the score of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The score results in the form of a string.
     */
    func getGameScoreString(gameId: Int64) -> String {
        var returnstring = ""
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let homeScore = Expression<Int64?>("homeScore")
            let awayScore = Expression<Int64?>("awayScore")
            var hScore = 0 as Int64
            var aScore = 0 as Int64
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(homeScore).filter(id == gameId)){
                hScore = game[homeScore] ?? -1
                if hScore > -1 {
                    returnstring.append(String(hScore))
                    returnstring.append("  -  ")
                }
            }
            for game in try db.prepare(games.select(awayScore).filter(id == gameId)){
                aScore = game[awayScore] ?? -1
                if aScore > -1 {
                    returnstring.append(String(aScore))
                }
            }
            if returnstring != "" {
                return returnstring
            }
        }
        catch {
            print(error)
        }
        return "No Score Available"
    }
    
    /**
     Get the id of the home team of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The id of the home team from the game as an interger.
     */
    func getHomeIdFromGameId(gameId:Int64) -> Int {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let home = Expression<Int64>("home")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(home).filter(id == gameId)){
                return Int(game[home])
            }
        }
        catch {
            print(error)
        }
        return 0
    }
    
    /**
     Get the id of the away team of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The id of the away team from the game as an integer.
     */
    func getAwayIdFromGameId(gameId:Int64) -> Int {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let away = Expression<Int64>("away")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(away).filter(id == gameId)){
                return Int(game[away])
            }
        }
        catch {
            print(error)
        }
        return 0
    }
    
    /**
     Get the title of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The title of the game as a string.
     */
    func getTitleFromGameId(gameId:Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let title = Expression<String>("title")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(title).filter(id == gameId)){
                return ("\(game[title])")
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the location id of a game from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The id for the location of the game as an integer.
     */
    func getLocationIdFromGameId(gameId:Int64) -> Int64 {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let location = Expression<Int64>("location")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(location).filter(id == gameId)){
                return (game[location])
            }
        }
        catch {
            print(error)
        }
        return 0
    }
    
    /**
     Get the date (and not the time) of a game as a string from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The string representing the date of the game.
     */
    func getDateStringFromTeamId(gameId:Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let date = Expression<String>("date")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(date).filter(id == gameId)){
                return ("\(game[date])")
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the time (and not the date) of a game as a string from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The string representing the time of the game.
     */
    func getTimeStringFromTeamId(gameId:Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let time = Expression<String>("time")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(time).filter(id == gameId)){
                return ("\(game[time])")
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the full date and time of a game as a string from the database given the game id.

     - Parameter gameId: The id of the game.

     - Returns: The string representing the date and time of the game.
     */
    func getFullDateTimeStringFromTeamId(gameId:Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let time = Expression<String>("time")
            let date = Expression<String>("date")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(date, time).filter(id == gameId)){
                return ("\(game[date]) \(game[time])")
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get all the games of a specific season from the database given the season id.

     - Parameter seasonId: The id of the current season.

     - Returns: An array of strings representing the names of the teams that are participating in the current season.
     */
    func getTeamsFromSeasonId(seasonId:NSNumber) -> [String] {
        let seasonIdString:String = "\(seasonId)"
        var teamArray:[String] = []
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let slug = Expression<String>("slug")
            let seasonID = Expression<String>("seasonID")
            //Table Names
            let teams = Table("Teams")
            for team in try db.prepare(teams.select(slug).filter(seasonID.like("%" + seasonIdString + "%"))){
                teamArray.append("\(team[slug])")
            }
        }
        catch {
            print(error)
        }
        return teamArray
    }
    
    /**
     Get the id of a team given the name of the team.

     - Parameter teamName: The name of the team.

     - Returns: The id belonging to that specific team as an integer.
     */
    func getTeamIdFromTeamName(teamName:String) -> Int64 {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let slug = Expression<String>("slug")
            let id = Expression<Int64>("id")
            //Table Names
            let teams = Table("Teams")
            for team in try db.prepare(teams.select(id).filter(slug == teamName)){
                return(team[id])
            }
        }
        catch {
            print(error)
        }
        return 0
    }
    
    /**
     Get all ids of the games involving a particular team given the id of the team.

     - Parameter teamId: The id of the team.

     - Returns: A list of game ids tracking all the games that involve the team.
     */
    func getAllGameIdsFromTeamId(teamId:Int64) -> [Int64]{
        var gameIdList:[Int64] = []
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let home = Expression<Int64>("home")
            let away = Expression<Int64>("away")
            
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games.select(id).filter(away == teamId || home == teamId)){
                gameIdList.append(game[id])
            }
        }
        catch {
            print(error)
        }
        return gameIdList
    }
    
    /**
     Schedules reminders of all the games of a team given an array of all their games. This is specifically used when the user opts in for notifications of a particular team.

     - Parameter idList: List of integers representing the game ids for a team.

     */
    func scheduleAllTeamGames(idList:[Int64]){
      
        for n in 0..<idList.count {
            // For all the games in the idList, schedule them
            scheduleLocal(dateTimeString: getFullDateTimeStringFromTeamId(gameId: idList[n]), notificationId: String(idList[n]), titleString: getTitleFromGameId(gameId: idList[n]))
        }
    }
    
    /**
     Deletes all set notifications of the games of a team given an array of all their games. This is specifically used when the user opts out of notifications of a particular team.

     - Parameter idList: Array of integers representing the ids of the games for a team.

     */
    func deleteAllNotificationsOfTeamGames(idList:[Int64]){
        let defaults = UserDefaults.standard
        for n in 0..<idList.count {
            // For all the games in the idList, schedule them, they will be overwritten if they are already set
            deleteNotification(notificationId: String(idList[n]))
            // if there exists a key for the element, set it to false, otherwise, do not take up memory
            if defaults.object(forKey: String(idList[n])) != nil{
                defaults.setValue(false, forKey: String(idList[n]))
            }

        }
        // Upon deletion of the games involving a team, ensure to schedule all games based off the preferences so that games involving other preferences aren't also cancelled.
        updateScheduledGamesFromPreferences()
    }
    
    /**
     This function checks all the user defaults for the teams and updates the notifications for those games as well. This is in the case when a new game is added that fits a preference and thus need to ensure that game is also added without requiring user input.
     */
    func updateScheduledGamesFromPreferences(){
        let defaults = UserDefaults.standard
        let teams = getTeamsFromSeasonId(seasonId: defaults.object(forKey: "currSeason") as! NSNumber)
        for n in 0..<teams.count {
            if defaults.bool(forKey: teams[n]){
                let teamId = getTeamIdFromTeamName(teamName: teams[n])
                let gameIdList = getAllGameIdsFromTeamId(teamId: teamId)
                scheduleAllTeamGames(idList: gameIdList)
            }
        }
    }
}

extension UIViewController {
    
    func getCurrentSeasonName(seasonId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let name = Expression<String>("name")
            let id = Expression<Int64>("id")
            //Table Name
            let seasons = Table("Seasons")
            for season in try db.prepare(seasons.select(name).filter(id == seasonId)){
                return season[name]
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
     Get the data to populate the standings spreadsheets.
     
     - Returns: An array of the strings matching the order of the data for the spreadsheet.

     */
    func getStandingsInOrder() -> [String]{
        var returnArray: [String] = []
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            let name = Expression<String>("name")
            let gp = Expression<String?>("gp")
            let w = Expression<String?>("w")
            let l = Expression<String?>("l")
            let t = Expression<String?>("t")
            let ga = Expression<String?>("ga")
            let gf = Expression<String?>("gf")
            let pts = Expression<String?>("pts")
            let pos = Expression<String?>("pos")
            let id = Expression<Int64>("id")
            let standings = Table("Standings")
        
            for standing in try db.prepare(standings.order(pos)) {
                returnArray.append(standing[pos] ?? "0")
                returnArray.append(standing[name])
                returnArray.append(standing[gp] ?? "0")
                returnArray.append(standing[w] ?? "0")
                returnArray.append(standing[l] ?? "0")
                returnArray.append(standing[t] ?? "0")
                returnArray.append(standing[pts] ?? "0")
                returnArray.append(standing[gf] ?? "0")
                returnArray.append(standing[ga] ?? "0")
            }
        }
        catch {
            print(error)
        }
        return returnArray
    }
    
    
    /**
     Get all the games of a specific season from the database given the season id.

     - Parameter seasonId: The id of the current season.

     - Returns: An array of integers representing the ids of the teams that are participating in the current season.
     */
    func getTeamIds(seasonId:String) -> [Int64] {
        var teamArray:[Int64] = []
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let seasonID = Expression<String>("seasonID")
            //Table Names
            let teams = Table("Teams")
            for team in try db.prepare(teams.select(id).filter(seasonID.like("%" + seasonId + "%"))){
                teamArray.append(team[id])
            }
        }
        catch {
            print(error)
        }
        return teamArray
    }
    
    /**
     Get the content/description of the player from the database given a player id.
     
     - Parameter playerId: The id of the player.

     - Returns: The content of the player as a string.
     */
    func getPlayerContentFromId(playerId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let content = Expression<String>("content")
            let id = Expression<Int64>("id")
            //Table Name
            let players = Table("Players")
            for player in try db.prepare(players.select(content).filter(id == playerId)){
                return player[content]
            }
        }
        catch {
            print(error)
        }
        return ""
    }

   
    
    /**
     Get the player id from the database given the name of the player to compare to.

     - Parameter playerName: The name of the player.

     - Returns: An integer representing the player id corresponding to the given player name.
     */
    func getPlayerIDFromPlayerName(playerName: String) -> Int64 {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let name = Expression<String>("name")
            let id = Expression<Int64>("id")
            //Table Name
            let players = Table("Players")
            for player in try db.prepare(players.select(id).filter(name == playerName)){
                return player[id]
            }
        }
        catch {
            print(error)
        }
        return -1
    }
    
    /**
     Get all the image url for the player from the database given the player id.

     - Parameter playerId: The id of the player.

     - Returns: An string representing the image url of the player
     */
    func getPlayerImageFromId(playerId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let mediaURL = Expression<String>("mediaURL")
            let id = Expression<Int64>("id")
            //Table Name
            let players = Table("Players")
            for player in try db.prepare(players.select(mediaURL).filter(id == playerId)){
                return player[mediaURL]
            }
        }
        catch {
            print(error)
        }
        return ""
    }
    
    /**
    Get the current team of the player from the database given player id.

     - Parameter playerId: The id of the player.

     - Returns: A string representing the current team of player.
     */
    func getPlayerCurrTeamFromId(playerId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let currTeam = Expression<Int64>("currTeam")
            let name = Expression<String>("name")
            let id = Expression<Int64>("id")
            //Table Name
            let players = Table("Players")
            let teams = Table("Teams")
            for player in try db.prepare(players.select(currTeam).filter(id == playerId)){
                for team in try db.prepare(teams.select(name).filter(id == player[currTeam])){
                    return team[name]
                }
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }
    
    /**
    Get the the number of the player from the database given the player id.

     - Parameter playerId: The id of the player.

     - Returns: A string representing the player's number.
     */

    func getPlayerNumberFromId(playerId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let number = Expression<Int64>("number")
            let id = Expression<Int64>("id")
            //Table Name
            let players = Table("Players")
            for player in try db.prepare(players.select(number).filter(id == playerId)){
                return String(player[number])
            }
        }
        catch {
            print(error)
        }
        return "00"
    }
    
    /**
    Get the name of the team from the database given the team's id.

     - Parameter teamId: The id of the team.

     - Returns: A string representing the name of the team.
     */
    func getTeamNameFromTeamId(teamId: Int64) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let name = Expression<String>("name")
            let id = Expression<Int64>("id")
            //Table Names
            let teams = Table("Teams")
            for team in try db.prepare(teams.select(name).filter(id == teamId)){
                return(team[name])
            }
        }
        catch {
            print(error)
        }
        return "N/A"
    }

    /**
    Get the data to populate the standings through querying the database for the pertinent information given the team id.

     - Parameter teamId: The id of the team.

     - Returns: An array of strings representing the data for the standings of the team.
     */
    func getStandingsFromTeamId(teamId: Int64) -> [String] {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var returnArray: [String] = []
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let gp = Expression<String?>("gp")
            let w = Expression<String?>("w")
            let l = Expression<String?>("l")
            let t = Expression<String?>("t")
            let ga = Expression<String?>("ga")
            let gf = Expression<String?>("gf")
            let pts = Expression<String?>("pts")
            let pos = Expression<String?>("pos")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            //Table Names
            let standings = Table("Standings")
        
            for team in try db.prepare(standings.filter(id == teamId)){
                returnArray.append(team[pos] ?? "0")
                //returnArray.append(team[name] ?? "n/a")
                returnArray.append(team[gp] ?? "0")
                returnArray.append(team[w] ?? "0")
                returnArray.append(team[l] ?? "0")
                returnArray.append(team[t] ?? "0")
                returnArray.append(team[pts] ?? "0")
                returnArray.append(team[gf] ?? "0")
                returnArray.append(team[ga] ?? "0")
            }
        }
        catch {
            print(error)
        }
        return returnArray
    }
}

extension SinglePlayerSpreadsheetViewController {
    
    
    func getPlayerData(pid: Int64) -> [String] {
        let sharedPref = UserDefaults.standard
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let currSeason = sharedPref.integer(forKey: "currSeason")
        var returnArray: [String] = []
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let team = Expression<Int64>("currTeam")
            let g = Expression<Int64>("goals")
            let a = Expression<Int64>("assists")
            let gp = Expression<String?>("gp")
            let pts = Expression<Int64>("points")
            let id = Expression<Int64>("id")
            //Table Names
            let players = Table("Players")
        
            for player in try db.prepare(players.filter(id == pid)){
                returnArray.append(getCurrentSeasonName(seasonId: Int64(currSeason)))
                returnArray.append(getTeamNameFromTeamId(teamId: player[team]) )
                returnArray.append(String(player[pts]))
                returnArray.append(String(player[g]))
                returnArray.append(String(player[a]))
                returnArray.append(player[gp] ?? "0")
            }
        }
        catch {
            print(error)
        }
        return returnArray
    }
    
}

extension Service {
    /**
     Get all the games of a specific season from the database given the season id.

     - Parameter seasonId: The id of the current season.

     - Returns: An array of integers representing the ids of the team that are participating in the current season.
     */
    func getTeamIds(seasonId:String) -> [Int64] {
        var teamArray:[Int64] = []
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            let id = Expression<Int64>("id")
            let seasonID = Expression<String>("seasonID")
            //Table Names
            let teams = Table("Teams")
            for team in try db.prepare(teams.select(id).filter(seasonID.like("%" + seasonId + "%"))){
                teamArray.append(team[id])
            }
        }
        catch {
            print(error)
        }
        return teamArray
    }
}
