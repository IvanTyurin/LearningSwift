//
//  AlertHandler.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 26.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class AlertHandler {
    private static let alertWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindow.Level.alert + 1
        return window
    }()

    private var alertController: UIAlertController

    init(title: String?,
         message: String?) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    }

    func addAction(title: String?,
                   style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title,
                                   style: style) { action in
                                    handler?(action)
                                    AlertHandler.alertWindow.isHidden = true
        }
        alertController.addAction(action)
    }

    func present() {
        AlertHandler.alertWindow.rootViewController = UIViewController()
        AlertHandler.alertWindow.makeKeyAndVisible()
        AlertHandler.alertWindow.rootViewController?.present(alertController,
                                                             animated: true,
                                                             completion: nil)
    }
}
