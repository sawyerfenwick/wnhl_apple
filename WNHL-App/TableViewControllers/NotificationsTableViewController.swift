//
//  NotificationsTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import Foundation
import Swift
import UIKit
import SQLite

// This protocol is called by the parent view to this class which is NotificationsViewController such that information can be passed to the parent from this child view.
protocol ChildToParentProtocol:AnyObject {
    
    func needToPassInfoToParent(with isNowChecked:Bool, teamNameString:String)
    
}

class NotificationsTableViewController: UITableViewController {
    @IBOutlet var NotificationsTableView: UITableView!
    // instantianting a ChildToParentProtocol object so that it is prepared for sending information to the parent.
    weak var delegate:ChildToParentProtocol? = nil
    // This attribute will allow this class to access the UserDefaults of the application which is effectively persistent preferences from the user.
    let defaults = UserDefaults.standard
    // the indentifier for the cell to modify.
    var reuseIdentifier = "notificationTableCell"
    var fontSize:CGFloat = 16
    var teams:[String] = []
    
    // MARK: - Table view data source
    // Only 1 section will be needed for the table and thus 1 can be entered for the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Setting the number of rows for each section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    // When a button is selected on this table, the button will be toggled as opposed to taking the user to another view via segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var gameIds:[Int64] = []
        let indexPath = NotificationsTableView.indexPathForSelectedRow
        // Get the cell at the particular row index and instantiate it as the custom table view cell made for this class.
        let cell = NotificationsTableView.cellForRow(at: indexPath!) as! NotificationTableViewCell
        // Populate the gameIds array by calling the database extension function that will return an array of all the game ids given a teamId
        gameIds = getAllGameIdsFromTeamId(teamId: getTeamIdFromTeamName(teamName: teams[indexPath!.row]))
        // Track the number of the the button selected such that it can be used as the unique key
        let rowNumber:Int = indexPath!.row
        // Archive the name of the team into a string for the toast message
        let teamNameString:String = cell.teamLabel.text!
        // Check if the button has been toggled and toggle if it is not. Vice versa if it is not toggled.
        // If the isSelected boolean is false, it means the option has yet to be toggled.
        if cell.checkButton.isSelected == false{
            // Toggle the state of the isSelected boolean
            cell.checkButton.isSelected = true
            // Set the state of the button to be preserved in the defaults given a unique key. Set it to true if it is false
            defaults.setValue(true, forKey: teams[rowNumber])
            // Since the notifications for all games of this team has just been set, schedule all the games of that team.
            scheduleAllTeamGames(idList: gameIds)
            // Access the function of the delegate to pass both a boolean and string to the parent view (NotificationsViewController)
            delegate?.needToPassInfoToParent(with: true, teamNameString: teamNameString)
        }
        // Otherwise, the isSelected boolean is true which means it is already toggled.
        else{
            // Toggle the state of the isSelected boolean
            cell.checkButton.isSelected = false
            // Set the boolean in this key as false to reflect the toggle
            defaults.setValue(false, forKey: teams[rowNumber])
            // Delete all the set notifications of that team since they have been opted out of being notified for all the games of that team.
            deleteAllNotificationsOfTeamGames(idList: gameIds)
            // Access the function of the delegate to pass both a boolean and string to the parent view (NotificationsViewController)
            delegate?.needToPassInfoToParent(with: false, teamNameString: teamNameString)
        }
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate the cell as the custom TableViewCell made for this collection view.
        let cell = NotificationsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        // Set the row number as an integer
        let rowNumber:Int = indexPath.row
        // Set the teamString as the team string held at each index
        var teamString = teams[indexPath.row]
        // Omit the hyphens in the team name as it is held in the database as "atlas-steelers" or "lincoln-street-legends"
        teamString = teamString.replacingOccurrences(of: "-", with: " ")
        
        // Set the initial state for each of the buttons to be false since the user is not opted in to any team by default.
        cell.checkButton.isSelected = defaults.bool(forKey: teams[rowNumber])
        // Set the text of the teamLabel to be that of the teamString pulled from the database but capitalized.
        cell.teamLabel.text = teamString.uppercased()
        cell.teamLabel.textColor = UIColor.white
        cell.teamLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        
        // Set the background image of the checkButtons to be that of a square that has an empty inside if the check button is not selected (i.e. false)
        cell.checkButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        // Otherwise set it to a square with a checkmark on the inside if the check button is selected (i.e. is set to true)
        cell.checkButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        // The same functionality at the didSelectRowAt yet for the actual checkbox button itself.
        cell.checkButton.mk_addTapHandler { (btn) in
            self.buttonClicked(cell: cell, rowNumber: rowNumber)
        }
        cell.noSelectionStyle()
        return cell
    }
    
    override func viewDidLoad() {
        // Fetch the teams to opt in and out of based off the teams participating in the current season. Not simply all teams.
        teams = getTeamsFromSeasonId(seasonId: defaults.object(forKey: "currSeason") as! NSNumber)
        super.viewDidLoad()
    }
    
    /**
     Toggles the button to be selected if deselected and vice versa. Sets the defaults for the team's notifications accordingly and finally either sets them all or cancels them all.
     - Parameter cell: The table view cell from which the information of the team will be derived from.
     - Parameter rowNumber: The integer matching the index of the row
     */
    func buttonClicked(cell:NotificationTableViewCell, rowNumber: Int) {
        var gameIds:[Int64] = []
        gameIds = getAllGameIdsFromTeamId(teamId: getTeamIdFromTeamName(teamName: teams[rowNumber]))
        let teamNameString:String = cell.teamLabel.text!
        if cell.checkButton.isSelected == false{
            cell.checkButton.isSelected = true
            print(teams[rowNumber])
            defaults.setValue(true, forKey: teams[rowNumber])
            // As the team has been opted in for, the phone should schedule all games for the respective team.
            scheduleAllTeamGames(idList: gameIds)
            // Access the function of the delegate to pass both a boolean and string to the parent view (NotificationsViewController)
            delegate?.needToPassInfoToParent(with: true, teamNameString: teamNameString)
        }
        else{
            cell.checkButton.isSelected = false
            defaults.setValue(false, forKey: teams[rowNumber])
            // As it has been toggled off, the phone should delete all scheduled games for that team
            deleteAllNotificationsOfTeamGames(idList: gameIds)
            // Access the function of the delegate to pass both a boolean and string to the parent view (NotificationsViewController)
            delegate?.needToPassInfoToParent(with: false, teamNameString: teamNameString)
        }
        
    }
}



