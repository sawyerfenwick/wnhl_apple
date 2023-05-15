//
//  LaunchViewController.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-09-03.
//

import UIKit
import SQLite
import Reachability

class LaunchViewController: UIViewController {
    
    //Path to DB
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let reachability = try! Reachability()
    public var downloading: Bool = true
    
    @IBOutlet weak var textLabel: UILabel!
    // Downloading Data for first time
    // Checking for Updates subsequent runs
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = ""
        overrideUserInterfaceStyle = .light
                
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 60),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachability.stopNotifier()
    }
    
    let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.white], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    // Called once the view is prepared
    override func viewDidAppear(_ animated: Bool) {
        do_stuff {
            
        }
    }
    
    /**
     Basic function with a completion handler that will run the body to completion prior to calling its completion tag and proceeding execution of the application as a whole.
     */
    func do_stuff(onCompleted: () -> ()) {
        loadingIndicator.animateStroke()
        if isAppAlreadyLaunchedOnce() {
            textLabel.text = "Checking for Updates..."
        }
        else{
            textLabel.text = "Downloading Data..."
        }
        let service = Service(baseUrl: "http://www.wnhlwelland.ca/wp-json/sportspress/v2/", launchView: self)
        if self.isAppAlreadyLaunchedOnce() {
            if NetworkManager.shared.isConnected {
                //Update DB
                service.updateDatabase(updateMain: true)
            }
            else {
                showToast(message: "No Internet Connection. Cannot Update WNHL App.", font: .systemFont(ofSize: 12))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                }
            }
        }
        else {
            if NetworkManager.shared.isConnected {
                //Create DB
                SQLiteDatabase.init()
                //Begin Network Calls
                service.buildDatabase(update: false)
                //The onCompleted flag is necessary
            }
            else {
                showToast(message: "No Internet Connection. Cannot Download Data.", font: .systemFont(ofSize: 12))
                textLabel.text = "Reconnect to the Internet and Try Again"
            }
            
        }
        onCompleted()
    }
    
    /**
     Checks of the defaults of the key isAppAlreadyLaunchedOnce to check if the app is experiencing its first launch or a subsequent launch.
     - Returns: True if the app has already launched once as the app is set true on the first run and is otherwise nil prior to that. In that case, False is returned.
     */
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return true
        }else{
            return false
        }
    }
    
    func goToNext(){
        self.textLabel.text = "Finishing Up..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.textLabel.text = "Complete!"
            self.performSegue(withIdentifier: "mainSegue", sender: self)
        }
    }
}
