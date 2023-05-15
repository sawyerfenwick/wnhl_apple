//
//  UpdateTableViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit
import Network
import Alamofire

class UpdateTableViewController: UITableViewController {
    @IBOutlet var UpdateTableView: UITableView!
    // Static titles for the titles of each row.
    var categories = ["PLAYERS","GAME SCHEDULE","TEAMS","STANDINGS","EVERYTHING",]
    // icon names for the system images for each row in addition to a custom one from assets.
    var iconNames = ["person.fill", "calendar", "hockeyStickUpdate", "chart.bar.xaxis", "square.and.arrow.down",]
    var reuseIdentifier = "updateTableCell"
    var fontSize:CGFloat = 16
    // This is responsible for the height of the spacing between each row in pixels
    let cellSpacingHeight: CGFloat = 10
    // Service object that will provide the ability to interact with the wordpress data for WNHL
    let service = Service(baseUrl: "http://www.wnhlwelland.ca/wp-json/sportspress/v2/")
    
    // MARK: - Table view data source
    // Only 1 section will be needed for the table and thus 1 can be entered for the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Setting the number of rows for each section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // This function monitors the selection of a row in the table
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = UpdateTableView.indexPathForSelectedRow
        let rowNumber:Int = indexPath!.row as Int
        
        // Update the application based of the selection of the rows for different aspects of the app.
        switch rowNumber {
        // Players
        case 0:
            if NetworkManager.shared.isConnected {
                //Alert Dialog to denote that the process has begun
                parent?.showSpinner()
                // Call the function to update the respective aspect of data depending on which was selected.s
                service.updatePlayers(tableView: self)
            }
            else {
                showToast(message: "No Internet Connection. Try Again Later.", font:.systemFont(ofSize: 12))
            }
            break
        // Game Schedule
        case 1:
            if NetworkManager.shared.isConnected {
                //Alert Dialog
                parent?.showSpinner()
                service.updateEvents(tableView: self)
            }
            else {
                showToast(message: "No Internet Connection. Try Again Later.", font:.systemFont(ofSize: 12))
            }
            break
        // Teams
        case 2:
            if NetworkManager.shared.isConnected {
                //Alert Dialog
                parent?.showSpinner()
                service.updateTeams(tableView: self)
            }
            else {
                showToast(message: "No Internet Connection. Try Again Later.", font:.systemFont(ofSize: 12))
            }
            break
        // Standings
        case 3:
            if NetworkManager.shared.isConnected {
                //Alert Dialog
                parent?.showSpinner()
                service.updateStandings(tableView: self)
            }
            else {
                showToast(message: "No Internet Connection. Try Again Later.", font:.systemFont(ofSize: 12))
            }
            break
        // Everything
        default:
            if NetworkManager.shared.isConnected {
                //Alert Dialog
                parent?.showSpinner()
                service.updateApp(tableView: self)
            }
            else {
                showToast(message: "No Internet Connection. Try Again Later.", font:.systemFont(ofSize: 12))
            }
            break
        }
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instantiate the cell as the custom TableViewCell made for this collection view.
        let cell = UpdateTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UpdateTableViewCell
        
        // Setting the text from the element at this index in the categories array
        cell.updateLabel.text = categories[indexPath.row]
        cell.updateLabel.textColor = UIColor.white
        cell.updateLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
       
        // Set the imageView called iconImage to be that of an image with the name provided by the element at this index from the iconNames array
        cell.iconImage.image = UIImage(systemName: iconNames[indexPath.row])
        if cell.iconImage.image == nil{
            cell.iconImage.image = UIImage(named: iconNames[indexPath.row])
        }
        // Set the image to be white to ensure it appears on the Orange background.
        cell.iconImage.tintColor = UIColor.white
        // Set the selection style to be none which means there won't be a highlight upon selection of each cell.
        cell.noSelectionStyle()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if the user is connected upon the loading of the view
        monitorNetwork()
    }
    
    /**
     This function checks if the user is connected to some form of network either through Wifi or Data for example as it is essential to downloading the updates for the app.
     Displays a toast to the device if the user is not in fact connected.
     */
    func monitorNetwork(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    //do nothing
                    print("connected")
                }
            }
            else {
                DispatchQueue.main.async {
                    self.showToast(message: "No Internet Connection. Try Again Later", font: .systemFont(ofSize: 12))
                    self.parent?.removeSpinner()
                }
            }
        }
        let queue = DispatchQueue(label: "Network")
        monitor.start(queue: queue)
    }
}
