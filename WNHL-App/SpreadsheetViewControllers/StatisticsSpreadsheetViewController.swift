//
//  StatisticsSpreadsheetViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-26.
//

import UIKit
import SQLite

// This class will create and populate the spreadsheets for the Statistics View
class StatisticsSpreadsheetViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    // GoalsCollectionView, AssistsCollectionView and PointsCollectionView are the collection views containing the data for the spreadsheets
    @IBOutlet var GoalsCollectionView: UICollectionView?
    @IBOutlet var AssistsCollectionView: UICollectionView?
    @IBOutlet var PointsCollectionView: UICollectionView?
    // The 3 headerCollectionViews will be the titles for the 4 columns of the spreadsheets
    @IBOutlet var headerCollectionView1: UICollectionView!
    @IBOutlet var headerCollectionView2: UICollectionView!
    @IBOutlet var headerCollectionView3: UICollectionView!
    // reuseIdentifiers for the cells of the actual spreadsheets with the data
    var reuseIdentifier1 = "goalsCell"
    var reuseIdentifier2 = "assistsCell"
    var reuseIdentifier3 = "pointsCell"
    // reuseIdentifiers for the header collection views such that their cells can be modified
    var reuseIdentifierHeader1 = "headerCell1"
    var reuseIdentifierHeader2 = "headerCell2"
    var reuseIdentifierHeader3 = "headerCell3"
    // CGFloat object to track the font of all the text
    var fontSize:CGFloat!
    // screenSize contains the dimensions of the screen so that the width and height can be referred to.
    let screenSize: CGRect = UIScreen.main.bounds
    // The strings that will go in each cell of the header collection views
    var headerItems1 = ["Rank","Player","Team","G"]
    var headerItems2 = ["Rank","Player","Team","A"]
    var headerItems3 = ["Rank","Player","Team","P"]

    // Path string connecting to the database
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    // Table name
    let players = Table("Players")
    // Column names of the table
    let name = Expression<String>("name")
    let currTeam = Expression<Int64>("currTeam")
    let goal = Expression<Int64>("goals")
    let assist = Expression<Int64>("assists")
    let point = Expression<Int64>("points")
    // The 3 arrays are for the Goals, Assists and Points spreadsheets respectively.
    var goals: [String] = []
    var assists: [String] = []
    var points: [String] = []
    
    // Set the number of items in the sole section, in other words, tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == GoalsCollectionView{
            return self.goals.count
        }
        else if collectionView == AssistsCollectionView{
            return self.assists.count
        }
        else if collectionView == PointsCollectionView{
            return self.points.count
        }
        else{
            return self.headerItems1.count
        }
    }
    
    // This function will set the layout the cells for the spreadsheets of this class in regard to width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // containerWidth tracks the wideth of the specific containerView holding this class.
        let containerWidth = view.frame.size.width
        // Max width of this component is 374 for the iPhone 11 variant. It is the basis for determining the correct width for every device
        var cellWidth:CGFloat = CGFloat()
        // Rank Column 45
        if indexPath.row == 0 || ((indexPath.row) % 4) == 0 {
            cellWidth = containerWidth * 0.1203
        }
        // Player Column 140
        else if indexPath.row == 1 || ((indexPath.row - 1) % 4) == 0 {
            cellWidth = containerWidth * 0.374
        }
        // Team Column 155
        else if indexPath.row == 2 || ((indexPath.row - 2) % 4) == 0{
            cellWidth = containerWidth * 0.414
        }
        // 4th column 34
        else{
            cellWidth = containerWidth * 0.09
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
        if collectionView == self.GoalsCollectionView {
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath as IndexPath) as! GoalsCollectionViewCell
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.dataLabel1.text = self.goals[indexPath.row] // The row value is the same as the index of the desired text within the array.
            cell.dataLabel1.font = UIFont.systemFont(ofSize: fontSize)

            return cell
        }
        else if collectionView == self.AssistsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier2, for: indexPath as IndexPath) as! AssistsCollectionViewCell
            cell.dataLabel2.text = self.assists[indexPath.row]
            cell.dataLabel2.font = UIFont.systemFont(ofSize: fontSize)
            return cell
        }
        else if collectionView == self.PointsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier3, for: indexPath as IndexPath) as! PointsCollectionViewCell
            cell.dataLabel3.text = self.points[indexPath.row]
            cell.dataLabel3.font = UIFont.systemFont(ofSize: fontSize)

            return cell
        }
        // This is responsible for the headers
        else if collectionView == self.headerCollectionView1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader1, for: indexPath as IndexPath) as! headerGoals
            cell.headerLabel.text = self.headerItems1[indexPath.row]
            cell.headerLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return cell
        }
        else if collectionView == self.headerCollectionView2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader2, for: indexPath as IndexPath) as! headerAssists
            cell.headerLabel.text = self.headerItems2[indexPath.row]
            cell.headerLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader3, for: indexPath as IndexPath) as! headerPoints
            cell.headerLabel.text = self.headerItems3[indexPath.row]
            cell.headerLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return cell
        }
    }
   
    override func viewDidLoad() {
        // Populate the goals, assists and points arrays with the respective pertinent data
        getGoals()
        getAssists()
        getPoints()
        // Set the delegate and datasource of all collectionViews to be this class.
        GoalsCollectionView?.delegate = self;
        GoalsCollectionView?.dataSource = self;
        AssistsCollectionView?.delegate = self;
        AssistsCollectionView?.dataSource = self;
        PointsCollectionView?.delegate = self;
        PointsCollectionView?.dataSource = self;
        headerCollectionView1?.delegate = self;
        headerCollectionView1?.dataSource = self;
        headerCollectionView2?.delegate = self;
        headerCollectionView2?.dataSource = self;
        headerCollectionView3?.delegate = self;
        headerCollectionView3?.dataSource = self;
        super.viewDidLoad()
    }
    
    /**
     Query the database and fetch the information for all the goals from the Players Table and populates the array in StatisticsSpreadsheetViewController with the result of the query.
     */
    func getGoals(){
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            
            let sortedPlayers = Table("Players").order(goal)
            
            var count = try! db.scalar(sortedPlayers.count)
        
            for player in try db.prepare(sortedPlayers) {
                goals.append(String(player[goal]))
                goals.append(getTeamNameFromTeamId(teamId: player[currTeam]))
                goals.append(player[name])
                goals.append(String(count))
                count-=1
            }
            goals.reverse()
        }
        catch {
            print(error)
        }
    }
    
    /**
     Query the database and fetch the information for all the assists from the Players Table and populates the array in StatisticsSpreadsheetViewController with the result of the query.
     */
    func getAssists(){
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            
            let sortedPlayers = Table("Players").order(assist)
            
            var count = try! db.scalar(sortedPlayers.count)
            
            for player in try db.prepare(sortedPlayers) {
                assists.append(String(player[assist]))
                assists.append(getTeamNameFromTeamId(teamId: player[currTeam]))
                assists.append(player[name])
                assists.append(String(count))
                count-=1
            }
            assists.reverse()
        }
        catch {
            print(error)
        }
    }
    
    /**
     Query the database and fetch the information for all the points from the Players Table and populates the array in StatisticsSpreadsheetViewController with the result of the query.
     */
    func getPoints(){
        do {
            let db = try Connection("\(path)/wnhl.sqlite3")
            
            let sortedPlayers = Table("Players").order(point)
            
            var count = try! db.scalar(sortedPlayers.count)
            
            for player in try db.prepare(sortedPlayers) {
                points.append(String(player[point]))
                points.append(getTeamNameFromTeamId(teamId: player[currTeam]))
                points.append(player[name])
                points.append(String(count))
                count-=1
            }
            points.reverse()
        }
        catch {
            print(error)
        }
    }
}
