//
//  CustomAlertPermisison.swift
//  customAlertPermission
//
//  Created by Ivan Tyurin on 05.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import Foundation
import PMAlertController

class CustomAlertPermission {
    
    let darkGreen = UIColor(red: 20.0/255.0, green: 72.0/255.0, blue: 71.0/255.0, alpha: 1.0)
    let green = UIColor(red: 51.0/255.0, green: 118.0/255.0, blue: 126.0/255.0, alpha: 1.0)
    let denyColor = UIColor.gray
       
    let customAlert = PMAlertController(title: "Test", description: "Permision", image: UIImage(named: "cat.png"), style: .alert)
    let allowButton = PMAlertAction(title: "Allow", style: .default, action: nil)
    let denyButton = PMAlertAction(title: "Don't Allow", style: .default, action: nil)
    
    static let shared = CustomAlertPermission()
    
    private init() {
    }
    
    func showIfNeeded(_ presenter: UIViewController) {
        
        let showStatus = checkDate()
        
        if showStatus {
            uiViewSetup()
            presenter.present(customAlert, animated: true, completion: nil)
        }
    }
    
    private func uiViewSetup() {
        customAlert.alertView.layer.cornerRadius = 20
        customAlert.headerViewHeightConstraint.constant = 80
        customAlert.headerViewTopSpaceConstraint.constant = 60
        customAlert.alertContentStackView.spacing = 2
        customAlert.alertContentStackViewTopConstraint.constant = 40
        customAlert.alertActionStackViewTopConstraint.constant = 40
        
        customAlert.alertTitle.textColor = darkGreen
        customAlert.alertTitle.font = UIFont(name: "Muli-Bold", size: 14.0)
        customAlert.alertDescription.textColor = darkGreen
        customAlert.alertDescription.font = UIFont(name: "Muli-Regular", size: 14.0)
        
        allowButton.addTarget(self, action: #selector(allowButtonPressed), for: .touchUpInside)
        denyButton.addTarget(self, action: #selector(denyButtonPressed), for: .touchUpInside)
        
        allowButton.setTitleColor(darkGreen, for: UIControl.State())
        allowButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 14.0)
        denyButton.setTitleColor(denyColor, for: UIControl.State())
        denyButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 14.0)
        
        allowButton.separator.backgroundColor = green.withAlphaComponent(0.8)
        
        customAlert.addAction(denyButton)
        customAlert.addAction(allowButton)
    }
    
    private func checkPermission() {
//        let currentNotificationCenter = UNUserNotificationCenter.current()
//
//        currentNotificationCenter.getNotificationSettings(completionHandler: { settings in
//            if settings.authorizationStatus == .authorized {
//                UserDefaults.standard.set(3, forKey: "numberOfShows")
//            }
//        })
//
    }
    
    private func checkDate() -> Bool {
        let defaults = UserDefaults.standard
        let weekTotalSeconds: TimeInterval = 7 //* 24 * 60 * 60
        let monthTotalSeconds: TimeInterval = 30 //* 7 * 24 * 60 * 60
        
        if defaults.object(forKey: "numberOfShows") == nil {
            defaults.set(0, forKey: "numberOfShows")
        }
        
        checkPermission()
        
        let showNumber = defaults.integer(forKey: "numberOfShows")
        
        switch showNumber {
        case 0:
            let nextShowDate = Date(timeIntervalSinceNow: weekTotalSeconds)
            
            defaults.set(1, forKey: "numberOfShows")
            defaults.set(nextShowDate, forKey: "alertPermissionNextShowDate")
            
            print("Alert show number of try: \(showNumber)")
            print("Current date: \(Date())")
            print("Next show date: \(nextShowDate)")
            return true
        
        case 1:
            if let nextShowDate = defaults.value(forKey: "alertPermissionNextShowDate") as? Date {
                let currentDate = Date()
                
                if(currentDate >= nextShowDate) {
                    let nextMonth = Date(timeIntervalSinceNow: monthTotalSeconds)
                    
                    defaults.set(2, forKey: "numberOfShows")
                    defaults.set(nextMonth, forKey: "alertPermissionNextShowDate")
                    
                    print("Alert show number of try: \(showNumber)")
                    print("Current date: \(currentDate)")
                    print("Next show date: \(nextShowDate)")
                    print(nextMonth)
                    return true
                } else { return false }
            }
            
        case 2:
            if let nextShowDate = defaults.value(forKey: "alertPermissionNextShowDate") as? Date {
                let currentDate = Date()
                
                if(currentDate >= nextShowDate) {
                    defaults.set(3, forKey: "numberOfShows")
                    
                    print("Alert show number of try: \(showNumber)")
                    print("Current date: \(currentDate)")
                    print("Next show date: \(nextShowDate)")
                    return true
                } else { return false }
            }
            
        default:
            print("Alert show number of try: \(showNumber)")
            return false
        }
        return false
    }
    
    @objc func allowButtonPressed() {
        let currentNotificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        currentNotificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if didAllow {
                UserDefaults.standard.set(3, forKey: "numberOfShows")
                print("User allowed notifications")
            } else {
                UserDefaults.standard.set(3, forKey: "numberOfShows")
                print("User denied notifications")
            }
            if let error = error {
                print(error)
            }
        }
        print("Allow")
    }
    
    @objc func denyButtonPressed() {
        print("Deny")
    }
}
