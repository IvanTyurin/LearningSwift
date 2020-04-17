//
//  ViewController.swift
//  Learning Swift Part1
//
//  Created by Ivan Tyurin on 30.03.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    let notificationID = "ColoredLife"
    var notNotificated = true
    
    @IBOutlet weak var red: UIImageView!
    @IBOutlet weak var yellow: UIImageView!
    @IBOutlet weak var green: UIImageView!
    @IBOutlet weak var blue: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        red.isUserInteractionEnabled = true
        yellow.isUserInteractionEnabled = true
        green.isUserInteractionEnabled = true
        blue.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(scheduleNotification), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //MARK: My functions
    @objc private func scheduleNotification() {
        removeNotifications(withIdentifires: [notificationID])
        
        let date = Date(timeIntervalSinceNow: 2)
        let content = UNMutableNotificationContent()
        content.title = "Псс, парень..."
        content.body = "Не забыл понажимать на картинки? Там прикольно..."
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
       
        let triggerNotificatin = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: triggerNotificatin)
        
        if notNotificated {
            notNotificated = false
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request, withCompletionHandler: nil)
        } else {
            print("The notification worked once")
        }
    }
    
    private func removeNotifications(withIdentifires identifires: [String]) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifires)
    }
    
    //MARK: Images click actions
    @IBAction func redImageClicked(_ sender: Any) {
        print("I'am Red Image!")
        let alertView = UIAlertController(title: "Red Picture", message: "Я прекрасно красный цвет!", preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Red Beautiful", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func yellowImageClicked(_ sender: Any) {
        print("I'am Yellow Image!")
        let alertView = UIAlertController(title: "Yellow Picture", message: "Я жёлтый как банан, как, как банан...", preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Yellow Beautiful", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func greenImageClicked(_ sender: Any) {
        print("I'am Green Image!")
        let alertView = UIAlertController(title: "Green Picture", message: "А я в цвет настроения!", preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Green Beautiful", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func blueImageClicked(_ sender: Any) {
        print("I'am Blue Image!")
        let alertView = UIAlertController(title: "Blue Picture", message: "Будь как водичка, сам ищи свой путь к океану.", preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title: "Blue Beautiful", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
}

