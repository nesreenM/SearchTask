//
//  Extensions.swift
//  SearchTask
//
//  Created by Nesreen Mamdouh on 12/13/17.
//  Copyright © 2017 dlc. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

extension UIView {
    func startShimmering(){
        let light = UIColor.white.withAlphaComponent(0.7).cgColor
        let alpha = UIColor.black.cgColor
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, light, alpha]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        
        gradient.locations = [0.4,0.5,0.6]
        self.layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0,0.1,0.2]
        animation.toValue = [0.8,0.9,1.0]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
        
    }
    
    func stopShimmering(){
        self.layer.mask = nil
    }
    
}
extension UIViewController{
    func addReachabilityObserver (reachability : Reachability){
        reachability.whenReachable = { _ in
        }
        
        reachability.whenUnreachable = { _ in
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }catch {
        }
    }
    
    func internetChanged(note : Notification) {
        
    }
    func displayNetworkLabel() -> UILabel {
        let networkLabel = UILabel()
        let transform = CGAffineTransform(translationX: 0, y: -32)
        networkLabel.backgroundColor = UIColor.darkGray
        networkLabel.alpha = 0.8
        networkLabel.text = "No internet connection"
        networkLabel.textAlignment = .center
        networkLabel.textColor = UIColor.white
        networkLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        networkLabel.transform = transform
        let screenSize = UIScreen.main.bounds.size
        networkLabel.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: 36)
        return networkLabel
    }
}
