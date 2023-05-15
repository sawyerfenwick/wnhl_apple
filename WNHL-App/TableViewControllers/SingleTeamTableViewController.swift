//
//  SingleTeamTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-27.
//

import UIKit
import SQLite

class SingleTeamTableViewController: UITableViewController {
   
    @IBOutlet var TeamScheduleTableView: UITableView!
    // variable to track the size of the phone screen such that text changes can be made to smaller devices
    let screenSize: CGRect = UIScreen.main.bounds
    // DataFormatters that exist so that the date can be converted to a more human readable format as opposed to how it is stored in the database.
    let inputDateFormatter = DateFormatter()
    let outputDateFormatter = DateFormatter()
    // Same as above but converting the time to a more human readable format.
    let inputTimeFormatter = DateFormatter()
    let outputTimeFormatter = DateFormatter()
    let dateFormatter = ISO8601DateFormatter()
    // Get the current time by instantiating a Date object with no parameters.
    let currentTime = Date()
    // This attribute will allow this class to access the UserDefaults of the application which is effectively persistent preferences from the user.
    let defaults = UserDefaults.standard
    // identifier fot the cell to be modified of this TableView
    let reuseIdentifier = "gameListingCell"
    // This is responsible for the height of the spacing between each row in pixels
    let cellSpacingHeight: CGFloat = 30
    // Setting the font size for the text of the elements in the table view cells.
    var fontSize:CGFloat = 15
    // Variable tracking the teamId that is passed in from a previous view so that the stats and games information can be populated given the correct team id.
    var teamId:Int64!
    // Array holding the ids for all the games that will be displayed to the table view.
    var gameIds: [Int64] = []
    // MARK: - Table view data source
    
    // Set the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.gameIds.count
    }
    
    // Set the number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = TeamScheduleTableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! SingleTeamTableViewCell
        let gameIdString = String(gameIds[indexPath!.section])
        
        let alertTitle:String = currentCell.titleLabel.text!
        // Create the alert with Team vs Team String as a title and no message
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: UIAlertController.Style.alert)
        var reminderTitle = "Set Reminder"
        if defaults.bool(forKey: gameIdString) == true{
            reminderTitle = "Cancel Reminder"
        }
        // Add actions for the alert when it is called. Directions and Set Reminder have default styling
        alert.addAction(UIAlertAction(title: "Directions", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            // We will have to make a function that could translate these to the exact locations
            // *****
            self.showLocationOnMaps(primaryContactFullAddress: currentCell.locationLabel.text!)
        }))
        alert.addAction(UIAlertAction(title: reminderTitle, style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if self.defaults.bool(forKey: gameIdString) == true{
                self.deleteNotification(notificationId: gameIdString)
                self.defaults.setValue(false, forKey: gameIdString)
                self.parent?.showToast(message: "Reminder Cancelled", font: UIFont.systemFont(ofSize: 13.0))
            }
            else{
                let dateTimeString = self.getFullDateTimeStringFromTeamId(gameId: self.gameIds[indexPath!.section])
                self.scheduleLocal(dateTimeString: dateTimeString, notificationId: gameIdString, titleString: alertTitle)
                self.parent?.showToast(message: "Reminder Set", font: UIFont.systemFont(ofSize: 13.0))
            }
        }))
        // Cancel has unique styling to denote the level of action it is.
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        // Present the alert once it is completely set.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate the cell as the custom TableViewCell made for this collection view.
        let cell = self.TeamScheduleTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SingleTeamTableViewCell
        if screenSize.width < 414 {
            // Set the font of the dateLabel programmatically with a font of 15 or 14 if the width of the screen is lesser that that of iPhone 11
            fontSize = 14
        }
        // Convert the full date object from the database into a more human readable string using the input and output DateFormatters
        let dateInputString = inputDateFormatter.date(from: getDateStringFromTeamId(gameId: self.gameIds[indexPath.section]))
        let dateOutputString:String = outputDateFormatter.string(from: dateInputString!)
        // Same as above but for the time object.
        let timeInputString = inputTimeFormatter.date(from: getTimeStringFromTeamId(gameId: self.gameIds[indexPath.section]))
        let timeOutputString: String = outputTimeFormatter.string(from: timeInputString!) //pass Date here
        let isoDate = getGameDateString(gameId: self.gameIds[indexPath.section])+"T"+getGameTimeString(gameId: self.gameIds[indexPath.section])+"+0000"
        let gameDate = dateFormatter.date(from: isoDate)!
        
        // Set the dateLabel's text to be that fo the dateOutputString that was converted
        cell.dateLabel.text = dateOutputString
        cell.dateLabel.font = UIFont.systemFont(ofSize: fontSize)
        // Check if the current time of the game, if it has already passed then set the score for that game
        if currentTime < gameDate {
            cell.pointsLabel.text = timeOutputString
        }
        // Otherwise, set the time for the game since it would be upcoming if it fails the first case
        else{
            cell.pointsLabel.text = getGameScoreString(gameId: self.gameIds[indexPath.section])
        }
        cell.pointsLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        // Set the locationLabel with the name from the database given the game id.
        cell.locationLabel.text = getLocationNameFromId(locationId: getLocationIdFromGameId(gameId: self.gameIds[indexPath.section]))
        cell.locationLabel.font = UIFont.systemFont(ofSize: fontSize - 1.5)
        // The same for the title of the game given the gameId
        cell.titleLabel.text = getTitleFromGameId(gameId: self.gameIds[indexPath.section])
        cell.titleLabel.font = UIFont.systemFont(ofSize: fontSize - 1)
        
        // Set the alignment of the text with respect to the placements of the labels
        cell.dateLabel.textAlignment = NSTextAlignment.center
        cell.pointsLabel.textAlignment = NSTextAlignment.center
        cell.locationLabel.textAlignment = NSTextAlignment.center
        cell.titleLabel.textAlignment = NSTextAlignment.center
        
        // Setting the images of the Home Team and Away teams Logos by fetching their respective images.
        // Fetch the game id of the work to get the home team's id from that game and finally get the imageName given the teamId.
        cell.homeImage.image = UIImage(named: getImageNameFromTeamId(teamId: getHomeIdFromGameId(gameId: self.gameIds[indexPath.section])))
        cell.awayImage.image = UIImage(named: getImageNameFromTeamId(teamId: getAwayIdFromGameId(gameId: self.gameIds[indexPath.section])))
        // This makes it so that the selection of cells in the table views does not have a graphical effect.
        cell.noSelectionStyle()
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0
        // Corner radius is used to make the edges much rounder than normal.
        cell.layer.cornerRadius = 24
        cell.clipsToBounds = true
        return cell
    }
    
    override func viewDidLoad() {
        // Set the format for the input and output of the date formatter objects
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        outputDateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        inputTimeFormatter.dateFormat = "HH:mm:ss"
        outputTimeFormatter.dateFormat = "h:mm a"
        // Populate the array with the ids of the games that involve specifically this team.
        getGameIds()
        // Check all previously set notifications if there are in the past and cancel them if they were in the case and also remove them from memory.
        deletePastSetNotifications(idList: gameIds)
        // Set the delegate and dataSource for the schedule table to be that of the current view.
        TeamScheduleTableView.delegate = self
        TeamScheduleTableView.dataSource = self
        super.viewDidLoad()
    }
    
    /**
     This function interacts with the database and queries all the game ids from the Games table and populates the ids array of SingleTeamTableViewController with all the game ids such that the table view's cells can be created. The query checks for if the team exists as a home or away team for every match to populate the schedule.
     */
    func getGameIds(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do{
            let db = try Connection("\(path)/wnhl.sqlite3")
            //Table Column Names
            let id = Expression<Int64>("id")
            let home = Expression<Int64>("home")
            let away = Expression<Int64>("away")
            //Table Names
            let games = Table("Games")
            for game in try db.prepare(games){
                //if home or away id matches the team id add the game to the list
                if game[home] == teamId || game[away] == teamId{
                    gameIds.append(game[id])
                }
            }
        }
        catch {
            print(error)
        }
    }
}
