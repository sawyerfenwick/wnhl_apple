//
//  MyCollectionViewCell.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-11.
//

import UIKit

// The classes here are custom cell classes that were made to facilitate the components of the collection view cell for the spreadsheets. The label component of each of these are to be tracked by a special cell to allow more customization in those spreadsheets.

// The following 5 custom UICollectionViewCell classes serve as the dynamic cells for the 5 spreadsheets on Standings view
class SpreadsheetCollectionViewCell1:  UICollectionViewCell {
    // Outlets are linked from the component in the Storyboard assigned to this class. The label component in this case was linked and this allowed the creation of the IBOutlet which will allow for dynamic modification of the label
    // The variable is weak with the respective keyword. If the weak keyword is absent, the variable becomes strong. We make this variable weak as we don't need it to persist with its data after the respective view has terminated.
    // Lastly the "UILabel!" part of the variable of course denotes the type and the exclamation point is used to explicitly make it that type as it is ambiguous otherwise.
    @IBOutlet weak var posLabel: UILabel!
}

class SpreadsheetCollectionViewCell2: UICollectionViewCell {
    @IBOutlet weak var posLabel2: UILabel!
}

class SpreadsheetCollectionViewCell3: UICollectionViewCell{
    @IBOutlet weak var posLabel3: UILabel!
}

class SpreadsheetCollectionViewCell4: UICollectionViewCell{
    @IBOutlet weak var posLabel4: UILabel!
}

class SpreadsheetCollectionViewCell5: UICollectionViewCell{
    @IBOutlet weak var posLabel5: UILabel!
}

class headerStandings: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}

class headerFirstSingleTeam: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}

class headerSecondSingleTeam: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}

class headerGoals: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}

class headerAssists: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}

class headerPoints: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}
// The following 3 cells are used for the spreadsheets on the Statistics view
class GoalsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var dataLabel1: UILabel!
}
class AssistsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var dataLabel2: UILabel!
}
class PointsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var dataLabel3: UILabel!
}

// The following 2 cells are for the 2 spreadsheets of a singular team
class TeamSpreadsheetCollectionViewCell1: UICollectionViewCell{
    @IBOutlet weak var dataLabel1: UILabel!
}
class TeamSpreadsheetCollectionViewCell2: UICollectionViewCell{
    @IBOutlet weak var dataLabel2: UILabel!
}

// This cell is used for the data on the spreadsheet on the view for an individual player.
class SinglePlayerSpreadsheetCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var dataLabel: UILabel!
}

class headerSinglePlayer: UICollectionViewCell{
    @IBOutlet weak var headerLabel: UILabel!
}
