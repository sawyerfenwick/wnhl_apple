//
//  Extensions.swift
//  WNHL-App
//
//  Created by Daniel Figueroa on 2021-09-04.
//

import Foundation
import Swift
import UIKit
import SQLite

// This extensions of the UIViewController will allow all the functions within to be used by any UIViewController classes
extension UIViewController{
    
    /**
     Creates a black label with white text to display on the bottom of the screen displaying the provided message with provided font. It is meant to resemble a toast from Android OS.

     - Parameter message: Text that will be displayed in the
     - Parameter font: The size of the font for the message

     */
    func showToast(message : String, font: UIFont) {
        var toastOffset:CGFloat! = 0.0
        if self.view.frame.size.width <= 375 {
            toastOffset = 10.0
        }
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/10 - toastOffset , y: self.view.frame.size.height-125, width: 325, height: 35))
        // Setting the properties of the label
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        // Add the animation for the toast to fade out slowly
        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    /**
     Get the image string for the team's logo given the team's name.

     - Parameter teamName: The name of the team.

     - Returns: The image name for the logo from the assets.
     */
    func getImageNameFromTeamName(teamName:String) -> String {
        if teamName.caseInsensitiveCompare("Atlas Steelers")  == ComparisonResult.orderedSame{
            return "steelers_logo"
        }
        else if teamName.caseInsensitiveCompare("Townline Tunnelers") == ComparisonResult.orderedSame{
            return "townline_logo"
        }
        else if teamName.caseInsensitiveCompare("Crown Room Kings") == ComparisonResult.orderedSame{
            return "crownRoom_logo"
        }
        else if teamName.caseInsensitiveCompare("Dain City Dusters") == ComparisonResult.orderedSame{
            return "dusters_logo"
        }
        else if teamName.caseInsensitiveCompare("Lincoln Street Legends") == ComparisonResult.orderedSame{
            return "legends_logo"
        }
        else if teamName.caseInsensitiveCompare("Merritt Islanders") == ComparisonResult.orderedSame{
            return "islanders_logo"
        }
        else{
            return "WNHL_Logo"
        }
    }
    
    /**
     This function returns a color object depedent on the team name given.

     - Parameter teamName: The name of the team.

     - Returns: The specific color object that matches the team.
     */
    func getColorFromTeamId(teamName: String) -> UIColor{
        if teamName.caseInsensitiveCompare("Atlas Steelers")  == ComparisonResult.orderedSame{
            return UIColor(red: 216.0/255.0, green: 134.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        }
        else if teamName.caseInsensitiveCompare("Townline Tunnelers") == ComparisonResult.orderedSame{
            return UIColor(red: 0.0/255.0, green: 55.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        }
        else if teamName.caseInsensitiveCompare("Crown Room Kings") == ComparisonResult.orderedSame{
            return UIColor(red: 21.0/255.0, green: 21.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        }
        else if teamName.caseInsensitiveCompare("Dain City Dusters") == ComparisonResult.orderedSame{
            return UIColor(red: 224.0/255.0, green: 76.0/255.0, blue: 28.0/255.0, alpha: 1.0)
        }
        else if teamName.caseInsensitiveCompare("Lincoln Street Legends") == ComparisonResult.orderedSame{
            return UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        }
        else if teamName.caseInsensitiveCompare("Merritt Islanders") == ComparisonResult.orderedSame{
            return UIColor(red: 241.0/255.0, green: 104.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        }
        else{
            return UIColor.systemOrange
        }
    }
}


// extension will allow this to be an extension to all UITableViewControllers such that they can all use this function.
extension UITableViewController{
    
    /**
     Schedules a notification given a date to schedule it, an id to track the notification individually and control their state and a title for the notification. Does not schedule if the notification is set in the past or if it is already set.
     - Parameter dateTimeString: The full date object as a string. Written in the 'yyyy-MM-dd HH:mm:ss' format.
     - Parameter notificationId: The string version of the game id that will function as the id for this notification
     - Parameter titleString: The text that will display as the title for the notifications.

     */
    func scheduleLocal(dateTimeString:String, notificationId:String, titleString:String) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: notificationId) != true{
            let currentDate = Date()
            // game at 5:17PM tomorrow reads 22 hours when called at 6:17PM the day before.
            let date = convertStringToDate(dateStr: dateTimeString)
            // This will make it impossible for any past games to be scheduled by checking if the time between now and the time of the given date
            if date.timeIntervalSinceNow.isLessThanOrEqualTo(0) == false {
                let inputTimeFormatter = DateFormatter()
                let outputTimeFormatter = DateFormatter()
                inputTimeFormatter.dateFormat = "HH:mm:ss"
                outputTimeFormatter.dateFormat = "h:mm a"
                let timeInputString = inputTimeFormatter.date(from: getTimeStringFromTeamId(gameId: Int64(notificationId)!))
                let timeOutputString: String = outputTimeFormatter.string(from: timeInputString!) //pass Date here
                let content = UNMutableNotificationContent()
                content.title = titleString
                
                content.sound = UNNotificationSound.default
                // Furthermore, there will be a series of checks for an more than hour, more than 10 minutes and then within those 10 minutes
                var modifiedDate:Date!
                var triggerDate:DateComponents!
                var trigger:UNCalendarNotificationTrigger!
                // If there is more than an hour left, set the alert to be an hour prior to the game
                if date.hours(from: currentDate) > 0{
                    content.body = "1 hour until the match begins. " + titleString + " at " + timeOutputString + "."
                    //                content.body = "1 hour until the match begins."
                    modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: date)
                    triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate)
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    defaults.setValue(true, forKey: notificationId)
                }
                // If there is less than an hour left, but more than 10 minutes before the match begins, set the alert to be an hour prior to the game
                else if date.minutes(from: currentDate) > 10{
                    content.body = "10 minutes until the match begins. " + titleString + " at " + timeOutputString + "."
                    modifiedDate = Calendar.current.date(byAdding: .minute, value: -10, to: date)
                    triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: modifiedDate)
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    defaults.setValue(true, forKey: notificationId)
                }
                // Otherwise the user has less than 10 minutes meaning there is no reason to set a notification
                else{
                    content.body = "The match is in less than 10 minutes. " + titleString + " at " + timeOutputString + "."
                    defaults.setValue(true, forKey: notificationId)
                    trigger = nil
                }
                let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    if let error = error {
                        // Something went wrong
                        print(error)
                    }
                })
            }
        }
    }
    
    /**
     Delete a scheduled notification matching the id of the provided notification id.
     - Parameter notificationId: The id of the notification to delete.

     */
    func deleteNotification(notificationId:String){
        let idArray:[String] = [notificationId]
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: idArray)
    }
    
    /**
     This function deletes all notifications that may have passed and removes the from the userDefaults to keep the stored data at a minimum.

     - Parameter idList: array of the game ids to review and check if they have passed.
    
     */
    func deletePastSetNotifications(idList:[Int64]){
        let defaults = UserDefaults.standard
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        for n in 0..<idList.count {
            // If there is some data here, it mean it still exists and there may be a possibility a cancelled notification had past its time or an active one past its time
            let idString = String(idList[n])
            if defaults.object(forKey: idString) != nil{
                let gameDate = getFullDateTimeStringFromTeamId(gameId: idList[n])
                let dateFromString = dateFormatter.date(from: gameDate)
                // Check if the date of this notification is prior to current date. As in this very instant
                if dateFromString?.timeIntervalSinceNow.isLessThanOrEqualTo(0) == true{
                    // if the time since this notification to now is 0 or a negative, it means the notification has passed.
                    // Thus we remove the object entirely
                    defaults.removeObject(forKey: String(idList[n]))
                }
            }
        } // end of for loop
    }
    
    /**
     Opens Apple Maps with the query constructed from the provided string to pull up the the location of the game in Apple Maps.
     - Parameter primaryContactFullAddress: The string holding the region and name of the arena.
     
     */
    func showLocationOnMaps(primaryContactFullAddress: String) {
        let parts = primaryContactFullAddress.split(separator: "-")
        var direct:String!
        var arenaName = parts[1]
        var regionName = parts[0]
        arenaName.remove(at: arenaName.startIndex)
        regionName = regionName.dropLast()
        if arenaName == "Accipiter" || arenaName == "Duliban" {
            direct = "100+Meridian+Way,+Fonthill"
        }
        else if primaryContactFullAddress.contains("Arena") || primaryContactFullAddress.contains("arena") {
            direct = arenaName + ",+" + regionName
        }
        else{
            direct = arenaName + "+Arena,+" + regionName

        }
        print(direct!)
        let testURL: NSURL = NSURL(string: "maps://maps.apple.com/?q=")!
        if UIApplication.shared.canOpenURL(testURL as URL) {
            if let address = direct.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                let directionsRequest: String = "maps://maps.apple.com/?q=" + (address)
                print(directionsRequest)
                let directionsURL: NSURL = NSURL(string: directionsRequest)!
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(directionsURL as URL)) {
                    application.open(directionsURL as URL, options: [:], completionHandler: nil)
                }
            }
        } else {
            NSLog("Can't open Apple Maps on this device")
        }
    }
    
    /**
     This function will take the user to the Youtube channel of WNHL Welland when it is called.
     */
    func goToYoutubeChannel() {
        let youtubeChannelId:String = "UCklG51DEXWN6RodvW8Mj3cg"

        // appURL is the url for the Youtube app in particular
        let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(youtubeChannelId)")!
        // webURL is the url for initializing Youtube on the browser.
        let webURL = NSURL(string: "https://www.youtube.com/channel/\(youtubeChannelId)")!
        let application = UIApplication.shared
        // Check if the Youtube app can be opened first. This means the user has it installed already.
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
    
    /**
     This function will take the user to the Twitter account of WNHL Welland when it is called.
     */
    func goToTwitterAccount() {
        let twitterUserID:String = "WNHL2"
        // appURL is the url for the Twitter app in particular
        let appURL = NSURL(string: "twitter://user?screen_name=\(twitterUserID)")!
        // webURL is the url for the browser variant of Twitter
        let webURL = NSURL(string: "https://twitter.com/\(twitterUserID)")!
        
        let application = UIApplication.shared
        
        // Try to open the Twitter app first if it is installed, otherwise if that fails, open the Twitter account on browser.
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    /**
     This function will take the user to the Google Spreadsheets page for the WNHL Fantasy when it is called.
     */
    func goToFantasySpreadsheet(){
        let webURL = NSURL(string: "https://docs.google.com/spreadsheets/d/e/2PACX-1vQ8bY-Of5YbJHk0VTj0LxWyQLYkK2dzWea-2fjd899X3qWMXGysbmE2UhqCdsFBLtJ233WjsGA_IMYJ/pubhtml?gid=0&single=true")!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
    /**
     This function converts a string into a Date object entered in the proper format.

     - Parameter dateStr: A string in the formate of a Date object

     - Returns: The Date object constructed from that string
     */
    func convertStringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current// (abbreviation: "GMT+0:00")
        let dateFromString = dateFormatter.date(from: dateStr)
        return dateFromString!
    }
    
}

// This extension will allow all UITableViewCells, even the customs ones made, use the functions within
extension UITableViewCell {
    /**
     This function simply toggles the selection style to be that of none so that there won't be a grey highlight on click for cells.
     */
    func noSelectionStyle() {
        self.selectionStyle = .none
    }
}

extension UIButton {
    
    private class Action {
        var action: (UIButton) -> Void
        
        init(action: @escaping (UIButton) -> Void) {
            self.action = action
        }
    }
    
    private struct AssociatedKeys {
        static var ActionTapped = "actionTapped"
    }
    
    private var tapAction: Action? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionTapped, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionTapped) as? Action }
    }
    
    
    @objc dynamic private func handleAction(_ recognizer: UIButton) {
        tapAction?.action(recognizer)
    }
    
    
    func mk_addTapHandler(action: @escaping (UIButton) -> Void) {
        self.addTarget(self, action: #selector(handleAction(_:)), for: .touchUpInside)
        tapAction = Action(action: action)
        
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension NotificationsViewController:ChildToParentProtocol {
    
    /**
     Calls on a toast with a message dependent selection state of the particular team's notifications.

     - Parameter isNowChecked: The boolean tracking the state of the selection of the teams to opt in for all their notifications.
     - Parameter teamNameString: The name of the team.

     */
    func needToPassInfoToParent(with isNowChecked:Bool, teamNameString:String) {
        if isNowChecked{
            self.showToast(message: teamNameString + " Notifications ON", font: .systemFont(ofSize: 13.0))
        }
        else{
            self.showToast(message: teamNameString + " Notifications OFF", font: .systemFont(ofSize: 13.0))
        }
    }
}


extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension UITableViewController {
    
    /**
     Hides the spinner that was instantiated by calling the removeSpinner function.
     */
    func hideSpinner(){
        parent?.removeSpinner()
    }
}
