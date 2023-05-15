//
//  ScheduleTableViewCell.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-08-24.
//

import UIKit

// These classes represent the special UITableViewCell class designed for each respective table. It is required to make these to truly customize the cells as the prototype cells do not initially instantiate with all the needed components and therein lies the need to make these custom classes with the desired components.

// The following TableViewCell is used for the list of games on the Schedule view
class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var HomeImage: UIImageView!
    @IBOutlet weak var AwayImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}


// The following TableViewCell is used for listing of teams in the Teams View
class TeamTableViewCell: UITableViewCell{
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// The following TableViewCell is used for the listings of options in the More View
class MoreTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var moreTextLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// The following TableViewCell is used for the listing of players in the Players view through the More View
class PlayerTableViewCell: UITableViewCell {
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var chevronImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// The following TableViewCell is used for the listing of teams in the Notifications View through the More View
class NotificationTableViewCell: UITableViewCell{
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var teamLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// The following TableViewCell is used for the listing of option in the Update View through the More View
class UpdateTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var updateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// The following TableViewCell is used for the schedule in the SingleTeamTable View through the Teams View
class SingleTeamTableViewCell: UITableViewCell{
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
