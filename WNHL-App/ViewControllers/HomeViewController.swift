//
//  ViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-07-26.
//

import UIKit

class HomeViewController: UIViewController {
    
    var fontSize:CGFloat = 28
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    
    override func viewDidLoad() {
        scheduleTitleLabel.text = "UPCOMING GAMES"
        scheduleTitleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        super.viewDidLoad()
    }
    
}

