//
//  ViewController.swift
//  SenderApp
//
//  Created by Ivan Tyurin on 08.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var mapsButton: UIButton!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var receiverButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonDesign(mapsButton)
        buttonDesign(youtubeButton)
        buttonDesign(receiverButton)

    }

    private func buttonDesign(_ button: UIButton) {
        let layerBtn = button.layer

        layerBtn.cornerRadius = 6
        layerBtn.shadowOffset = CGSize(width: 0, height: 0)
        layerBtn.shadowRadius = 5
        layerBtn.shadowColor = UIColor.darkGray.cgColor
        layerBtn.shadowOpacity = 0.4
    }

    @IBAction func mapsButtonTapped(_ sender: UIButton) {
        let path = "http://maps.apple.com/?q="
        guard let searchQuerry = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: path + searchQuerry) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func youtubeButtonTapped(_ sender: Any) {
        let path = "https://youtube.com/results?search_query="
        guard let searchQuerry = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: path + searchQuerry) else { return }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func receiverButtonTapped(_ sender: Any) {
        let path = "receiverapp://"
        guard let searchQuerry = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: path + searchQuerry) else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "Reciever App Not Found!",
                                          message: "You may not have this application installed.",
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)

            self.present(alert, animated: true, completion: nil)
        }
        print(url)
    }

}

