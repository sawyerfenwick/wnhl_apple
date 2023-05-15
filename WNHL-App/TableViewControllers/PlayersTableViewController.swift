//
//  PlayersTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-25.
//

import UIKit
import SQLite

class PlayersTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var PlayerTableView: UITableView!
    let defaults = UserDefaults()
    // playerNameString refers to the string containing the name of the player which will be passed onto a subview.
    var playerNameString:String!
    // playersArray holds the name of all the players into an array to display to the table. It is the initial table used.
    var playersArray: [String] = []
    // filteredPlayers is another array that exists for the same purpose of the playersArray but will hold the results of the search. It initially starts a copy of playersArray.
    var filteredPlayers: [String]!
    // this is the identifier for the cell that will be modified for the table view.
    let reuseIdentifier = "playerCell"
    var fontSize:CGFloat = 16

    // MARK: - Table view data source
    // Only 1 section will be needed for the table and thus 1 can be entered for the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // The number of rows in the section will always be that of the filteredPlayers array as it is subject to getting smaller.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlayers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = PlayerTableView.indexPathForSelectedRow
        let currentCell = self.PlayerTableView.cellForRow(at:indexPath!) as! PlayerTableViewCell
        // Set a the passing variable to that of the player name which is in the playerText label of the cell.
        playerNameString = currentCell.playerNameLabel.text
        // Pass the playerId to the pertinent pages by setting it as a defaults.
        defaults.set(getPlayerIDFromPlayerName(playerName: playerNameString), forKey: "playerId") 
        // This will segue to the Navigation controller for the Single Player Front and Back Views
        self.performSegue(withIdentifier: "singlePlayerSegue", sender: self)
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate the cell as the custom TableViewCell made for this collection view.
        let cell = PlayerTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PlayerTableViewCell
        // Set the text of the playerNameLabel to be that of the filtered players elements as it will be updated to match the results of the search.
        cell.playerNameLabel.text = filteredPlayers[indexPath.row]
        // Set the text color to be white such that it will appear on the orange background better.
        cell.playerNameLabel.textColor = UIColor.white
        cell.playerNameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        
        // Set the image of the chevron images to be the same for each row as it will always be present.
        cell.chevronImage.image = UIImage(systemName: "chevron.right")
        // Set the color of the image to be white such that it appears better on the orange background.
        cell.chevronImage.tintColor = UIColor.white
        // Set the selection style to be none which means there won't be a highlight upon selection of each cell.
        cell.noSelectionStyle()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Populate the playerNames array with all the players in the players Table.
        getPlayerNames()
        // Set the filteredPlayers array to be that of the initial playersArray
        filteredPlayers = playersArray
    }
    
    // This function will be called just prior to the segue performed in the didSelectRowAt function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the navigation controller holding the View Controllers for Single Player selection
        let navigationController = segue.destination as! UINavigationController
        // Get a reference to the second view controller now that we have the Navigation controller that contains it
        let secondViewController = navigationController.viewControllers.first as! SinglePlayerFrontViewController
        
        // Set a variable in the second view controller with the playerNameString from this class.
        secondViewController.playerNameString = playerNameString
    }
    
    /**
     This function modifies the filteredPlayers array and updates it to reflect the results of the search and reloads the view to update the UI accordingly.
     - Parameter searchText: The string of the text in the search bar. 
     */
    func searchTableView(searchText:String){
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredPlayers = searchText.isEmpty ? playersArray : playersArray.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    /**
     This function interacts with the database and queries all the player names from the Players table and populates the playersArray of PlayersTableViewController with all the player names such that the table view's cells can be created.
     */
    func getPlayerNames(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            // Column name of the table
            let name = Expression<String>("name")
            // Table name
            let players = Table("Players")
            // Query the names of the players and append them to the playersArray.
            for player in try db.prepare(players) {
                playersArray.append(player[name])
            }
        }
        catch {
            print(error)
        }
    }
    
}
