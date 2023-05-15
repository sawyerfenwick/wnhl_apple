//
//  SecondSingleTeamSpreadsheetViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-27.
//

import UIKit
import SQLite

class SecondSingleTeamSpreadsheetViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    // singleTeamCollectionView will hold the data containing the data of the standings which go here
    @IBOutlet var singleTeamCollectionView: UICollectionView!
    // headerCollectionView is the spreadsheet that is identical to size as the one with the actual data and exists to act as the row for the titles of each column.
    @IBOutlet var headerCollectionView: UICollectionView!
    // reuseIdentifier for the cells of the actual spreadsheets with the data
    let reuseIdentifier = "teamSpreadsheetCell"
    // reuseIdentifierHeader for the cells of the header collection view
    let reuseIdentifierHeader = "headerCell"
    var fontSize:CGFloat!
    // The strings that will go in each cell of the header collection view
    var headerItems = ["Player","P","G","A"]
    // This is the team Id passed from the parent SingleTeamViewController
    var teamId:Int64!
    // screenSize contains the dimensions of the screen so that the width and height can be referred to.
    let screenSize: CGRect = UIScreen.main.bounds
    
    // Path string connecting to the database
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    // Table name
    let players = Table("Players")
    // Column names of the table
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let seasonID = Expression<String>("seasonID")
    let goals = Expression<Int64>("goals")
    let assists = Expression<Int64>("assists")
    let points = Expression<Int64>("points")
    let currTeam = Expression<Int64>("currTeam")
    // data is the array holding the information for the spreadsheet to display
    var data: [String] = []
    
    // Set the number of items in the sole section, in other words, tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == singleTeamCollectionView{
            return self.data.count
        }
        else {
            return self.headerItems.count
        }
        
    }
    
    // This function will set the layout the cells for the spreadsheets of this class in regard to width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let containerWidth = view.frame.size.width
        // Max width of this component is 374
        var cellWidth:CGFloat = CGFloat()
        // Player Column
        // 134
        if indexPath.row == 0 || ((indexPath.row) % 4) == 0 {
            cellWidth = containerWidth * 0.358
        }
        // P/G/A columns
        else{
            cellWidth = containerWidth * 0.213
        }
        return CGSize(width: cellWidth, height: 22)
    }
    
    // make a cell for each cell at each index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Check if the width of the screen is less than that of the iPhone 11, adjust the font to be smaller such that the text will fit.
        if screenSize.width < 390 {
            fontSize = 10
        }
        else{
            fontSize = 12
        }
        // Check for the correct collection view prior to populating the cell.
        if collectionView == singleTeamCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TeamSpreadsheetCollectionViewCell2
            cell.dataLabel2.text = self.data[indexPath.row] // The row value is the same as the index of the desired text within the array.
            cell.dataLabel2.font = UIFont.systemFont(ofSize: fontSize)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader, for: indexPath as IndexPath) as! headerSecondSingleTeam
            cell.headerLabel.text = self.headerItems[indexPath.row] // The row value is the same as the index of the desired text within the array.
            cell.headerLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return cell
        }
    }
    
    override func viewDidLoad() {
        // Query the information from the database to populate the data array that will be displayed on the spreadsheet
        do {
            let db = try Connection("\(self.path)/wnhl.sqlite3")
            
            for player in try db.prepare(players){
                if player[currTeam] == teamId {   //sub 1842 for teamID passed from button
                    data.append(player[name])
                    data.append(String(player[points]))
                    data.append(String(player[goals]))
                    data.append(String(player[assists]))
                }
            }
        }
        catch {
            print(error)
        }
        // Set the delegate and datasource of all collectionViews to be this class.
        singleTeamCollectionView?.delegate = self;
        singleTeamCollectionView?.dataSource = self;
        headerCollectionView?.delegate = self;
        headerCollectionView?.dataSource = self;
        super.viewDidLoad()
    }
}
