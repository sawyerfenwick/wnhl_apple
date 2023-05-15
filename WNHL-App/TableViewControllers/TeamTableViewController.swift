//
//  TeamTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-23.
//

import Foundation
import Swift
import UIKit
import SQLite

class TeamTableViewController: UITableViewController {
    @IBOutlet var teamTableView: UITableView!
    // Instantiating the object of the child view each selection will produce
    var SingleTeamViewController: SingleTeamViewController?
    // This attribute will allow this class to access the UserDefaults of the application which is effectively persistent preferences from the user.
    let defaults = UserDefaults.standard
    var teams:[String] = []
    var fontSize:CGFloat = 16
    // This string will be used to preserve the string from the teams array such that it can be sent to the child view controller.
    var passedTeamNameString:String!
    var passedTeamId:Int64!
    
    // Set the number of sections for the table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set the number of rows in each section of the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams.count
    }
    
    // Set functionality for when a row is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fetch the index of the selected row
        let indexPath = teamTableView.indexPathForSelectedRow
        // Using that index, get the cell object itself from the Table View
        let currentCell = self.teamTableView.cellForRow(at:indexPath!) as! TeamTableViewCell
        // Set the variable as the text of the teamNameLabel of that cell.
        passedTeamNameString = currentCell.teamNameLabel.text
        passedTeamId = getTeamIdFromTeamName(teamName: teams[indexPath!.row])
        // Perform the segue to the next/child view controller
        self.performSegue(withIdentifier: "singleTeamSegue", sender: self)
    }
    
    // Build the cell at each index for the provided data in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamTableViewCell
        var teamString = teams[indexPath.row]
        teamString = teamString.replacingOccurrences(of: "-", with: " ")
        // Set text of the teamNameLabel to be uppercase in the view
        cell.teamNameLabel.text = teamString.uppercased()
        // Setting the color to be white to ensure the label can be seen on the background.
        cell.teamNameLabel.textColor = UIColor.white
        // Setting the font of the rows in the TableView.
        cell.teamNameLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        
        // Setting the image using the system designation for the built in chevron image.
        cell.chevronImage.image = UIImage(systemName: "chevron.right")
        // Tint colour in particular will change the base colour of blue for the system images to white
        cell.chevronImage.tintColor = UIColor.white
        // noSelectionStyle denotes that there will be no highlight when an object is clicked
        cell.noSelectionStyle()
        return cell
    }
    
    override func viewDidLoad() {
        // The teams array will be populated by getting the teams partaking in the season provided by the object in the defaults under currSeason.
        teams = getTeamsFromSeasonId(seasonId: defaults.object(forKey: "currSeason") as! NSNumber)
        super.viewDidLoad()
    }
    
    // This function will be called just prior to the segue performed in the didSelectRowAt function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "singleTeamSegue") {
            // save reference to VC embedded in Container View
            let vc = segue.destination as? SingleTeamViewController
            self.SingleTeamViewController = vc
            // Set the attributes of that embedded view controller using attributes of this class. Effectively pass the attributes' values.
            self.SingleTeamViewController?.teamNameString = passedTeamNameString
            self.SingleTeamViewController?.teamId = passedTeamId
        }
    }
}
