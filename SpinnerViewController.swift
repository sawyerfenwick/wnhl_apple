//
//  SpinnerViewController.swift
//  WNHL-App
//
//  Created by sawyer on 2021-09-11.
//

import Foundation
import UIKit

var aView: UIView?

extension UIViewController{
    
    func showSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red:0.5,green: 0.5,blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner(){
        aView?.removeFromSuperview()
        aView = nil 
    }
}

extension LaunchViewController{
    
    func showLaunchSpinner(){
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red:0.5,green: 0.5,blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeLaunchSpinner(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
