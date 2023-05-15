//
//  SingleTeamSpreadsheetViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-27.
//

import UIKit
import SQLite

// This spreadsheet refers to the first spreadsheet in the SingleTeamSpreadsheetViewController that is immediately below the title of that view
class FirstSingleTeamSpreadsheetViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    // singleTeamCollectionView will hold the data containing the data of the standings which go here
    @IBOutlet var singleTeamCollectionView: UICollectionView!
    // headerCollectionView is the spreadsheet that is identical to size as the one with the actual data and exists to act as the row for the titles of each column.
    @IBOutlet var headerCollectionView: UICollectionView!
    // reuseIdentifier for the cells of the actual spreadsheets with the data
    let reuseIdentifier = "teamSpreadsheetCell"
    // reuseIdentifierHeader for the cells of the header collection view
    let reuseIdentifierHeader = "headerCell"
    // teamId is the passed variable from the previous view such that this spreadsheet can fetch the correct data
    var teamId:Int64!
    var fontSize:CGFloat!
    // screenSize contains the dimensions of the screen so that the width and height can be referred to.
    let screenSize: CGRect = UIScreen.main.bounds
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    // The strings that will go in each cell of the header collection view
    var headerItems: [String] = ["Pos","GP","W","L","T","PTS","GF","GA"]
    // data is the array holding the information for the spreadsheet to display
    var data: [String] = [
        "1", "11", "11", "61", "15", "50",  "13", "12"
    ]

    
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
        // containerWidth tracks the wideth of the specific containerView holding this class.
        let containerWidth = view.frame.size.width
        // Max width of this component is 374 for the iPhone 11 variant. It is the basis for determining the correct width for every device
        return CGSize(width: containerWidth * 0.125, height: 22)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TeamSpreadsheetCollectionViewCell1
            cell.dataLabel1.text = self.data[indexPath.row]
            cell.dataLabel1.font = UIFont.systemFont(ofSize: fontSize)
            cell.backgroundColor = UIColor.white
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader, for: indexPath as IndexPath) as! headerFirstSingleTeam
            cell.headerLabel.text = self.headerItems[indexPath.row]
            cell.headerLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            cell.backgroundColor = UIColor.white
            return cell
        }
       
    }
    
    override func viewDidLoad() {
        // Populate the array of the data array with the Standings information from the database
        data = getStandingsFromTeamId(teamId: teamId)
        // Set the delegate and datasource of all collectionViews to be this class.
        singleTeamCollectionView?.delegate = self;
        singleTeamCollectionView?.dataSource = self;
        headerCollectionView?.delegate = self;
        headerCollectionView?.dataSource = self;
        super.viewDidLoad()
    }

}
