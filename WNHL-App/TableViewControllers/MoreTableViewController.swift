//
//  MoreTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-24.
//

import UIKit

class MoreTableViewController: UITableViewController {
    @IBOutlet var MoreTableView: UITableView!
    // rowNames holds the names for all the rows in the the table and is hardcoded as this will not change based on season.
    var rowNames = ["PLAYERS", "STATISTICS","YOUTUBE", "TWITTER" ,"WNHL FANTASY", "NOTIFICATION SETTINGS", "UPDATE"]
    // iconNames holds the string names of all the system images and custom images to be loaded for each row.
    var iconNames = ["person.fill", "waveform.path.ecg", "youtube_logo","twitter_logo", "star.circle.fill", "bell.fill","clock.arrow.circlepath"]
    // the reuseIdentifier used to refer to the tableView cell that will be repeatedly modified.
    var reuseIdentifier = "MoreCell"
    var fontSize:CGFloat = 16

    
    // MARK: - Table view data source
    // This sets the number of sections for this table view. There is only one section needed.0
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This sets the number of rows in the sole section. Since both arrays will be the same size, it need only refer to the count of one of the arrays.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowNames.count
    }
    
    // Providing functionality for selection of each row element
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to the second view controller
        let indexPath = MoreTableView.indexPathForSelectedRow
        let rowNumber:Int = indexPath!.row as Int
        
        // Based off the selection of the rows, the user is taken to another view or their browser.
        switch rowNumber {
        // Players button
        case 0:
            // Execute the segue and transition to the view connected to this identifier
            self.performSegue(withIdentifier: "playersSegue", sender: self)
            break
        // Statistics button
        case 1:
            self.performSegue(withIdentifier: "statisticsSegue", sender: self)
            break
        // Youtube button
        case 2:
            // This string represents the id part of the Youtube URL for channels
            goToYoutubeChannel()
            break
        // Twitter button
        case 3:
            // This is a string representing the handle of the channel.
            goToTwitterAccount()
            break
        // WNHL Fantasy button
        case 4:
            goToFantasySpreadsheet()
            break
        // Notifications Settings button
        case 5:
            self.performSegue(withIdentifier: "notificationSegue", sender: self)
            break
        // Otherwise the last button by default is the Update button
        default:
            self.performSegue(withIdentifier: "updateSegue", sender: self)
            break
        }
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate the cell as the custom TableViewCell made for this collection view.
        let cell = MoreTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MoreTableViewCell
        // Set the text to be the that of the rowNames object at each index.
        cell.moreTextLabel.text = rowNames[indexPath.row]
        cell.moreTextLabel.textColor = UIColor.white
        cell.moreTextLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        
        // Set the image of the chevron images to be the same for each row as it will always be present.
        cell.chevronImage.image = UIImage(systemName: "chevron.right")
        cell.chevronImage.tintColor = UIColor.white
        
        // Set the image of the iconImage to be that of the string at this index in iconNames.
        cell.iconImage.image = UIImage(systemName: iconNames[indexPath.row])
        // The names in the iconNames array are not system images and are actually custom image sets and thus will be set to nil
        // As a result, check if the image set is still nil after the previous line
        if cell.iconImage.image == nil {
            // If it is still nill, set the image with the same strings but searching the custom images.
            if iconNames[indexPath.row] == "youtube_logo"{
                cell.iconImage.image = UIImage(named: "youtube_logo")
            }
            else{
                cell.iconImage.image = UIImage(named: "twitter_logo")
            }
        }
        // Set the color of the image to be white to ensure uniform appearance
        cell.iconImage.tintColor = UIColor.white
        // Set the selection style to be none which means there won't be a highlight upon selection of each cell.
        cell.noSelectionStyle()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
