//
//  SpreadsheetViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-11.
//

import UIKit

class StandingsSpreadsheetViewController: UITableViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    // Outlets for all the collection views on the Standings View
    @IBOutlet weak var titleLabel: UILabel!
    // CollectionView1 will hold the data containing the data of the standings
    @IBOutlet var CollectionView1: UICollectionView!
    // headerCollectionView is the spreadsheet that is identical to size as the one with the actual data and exists to act as the row for the titles of each column.
    @IBOutlet var headerCollectionView: UICollectionView!
    // reuseIdentifiers for the respective cells of the collection views such that they can be referenced here
    let reuseIdentifierData = "cell"
    let reuseIdentifierHeader = "headerCell"
    // fontSize will be used to control the font size of the data
    var fontSize:CGFloat!
    // The static set of items for the headers in the spreadsheet.
    var headerItems = ["Pos", "Team", "GP", "W", "L", "T", "PTS", "GF", "GA"]
    // screenSize contains the dimensions of the screen so that the width and height can be referred to.
    let screenSize: CGRect = UIScreen.main.bounds
    // The arrays housing the data for each respective collection view
    var spreadsheetData:[String] = []
    
    // MARK: - UICollectionViewDataSource protocol
    
    // Set the number of items in the sole section, in other words, tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Only make as many cells that the amount of the specific array for each collection view.
        // This is because not all the spreadsheets will have the same amount of data
        if collectionView == CollectionView1 {
            return self.spreadsheetData.count
        }
        else{
            return self.headerItems.count
        }
    }
    
    
    // This function will set the layout the cells for the spreadsheets of this class
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        // Calculate the width of the screen as this is a subview within a subview and thus getting the parent is not achievable
        let containerWidth = screenSize.width - 40

        // Max width of this component is 374 for the iPhone 11 variant. It is the basis for determining the correct width for every device
        var cellWidth:CGFloat = CGFloat()
        // Team title
        if indexPath.row == 1 || ((indexPath.row - 1) % 9) == 0 {
            // 145 is the width in pixels for a max width of 374
            cellWidth = containerWidth * (0.387)
        }
        // 1 Letter titles (W,L,T)
        else if indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 ||
                    ((indexPath.row - 3) % 9) == 0 || ((indexPath.row - 4) % 9) == 0 || ((indexPath.row - 5) % 9) == 0{
            // 23 is the width in pixels for a max width of 374
            cellWidth = containerWidth * (0.0625 )
        }
        // 2 letter titles (GP, GF, GA)
        // 3 letter title (PTS, Pos)
        else{
            // 32 is the width in pixels for a max width of 374
            cellWidth = containerWidth * (0.085 )
        }
        // Set the size of the cell to be of the determined width though all cells will have the exact same height of 22.
        return CGSize(width: cellWidth, height: 22)
    }
    
    
    // make a cell for each cell at each index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Check if the width of the screen is less than that of the iPhone 11, adjust the font to be smaller such that the text will fit.
        if screenSize.width < 414 {
            fontSize = 10
        }
        else{
            fontSize = 12
        }
        if collectionView == self.CollectionView1 {
            // get a reference to our storyboard cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierData, for: indexPath as IndexPath) as! SpreadsheetCollectionViewCell1
            // Use the outlet in our custom class to get a reference to the UILabel in the cell
            cell.posLabel.text = self.spreadsheetData[indexPath.row] // The row value is the same as the index of the desired text within the array.
            cell.posLabel.font = UIFont.systemFont(ofSize: fontSize)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierHeader, for: indexPath as IndexPath) as! headerStandings
            cell.headerLabel.text = self.headerItems[indexPath.row]
            cell.headerLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
            return cell
        }
    }
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
     This function reloads the spreadsheet data of the Collection View whenever called to reflect possible changes in data.
     */
    func reloadCollectionView() -> Void {
        self.CollectionView1.reloadData()
    }
    
}
