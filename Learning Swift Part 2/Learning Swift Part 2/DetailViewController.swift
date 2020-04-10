//
//  DetailViewController.swift
//  Learning Swift Part 2
//
//  Created by Ivan Tyurin on 10.04.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var pet: PowerPet? {
        didSet {
            refreshUI()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var weaponImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        nameLabel.text = pet?.name
        descriptionLabel.text = pet?.description
        iconImage.image = pet?.icon
        weaponImage.image = pet?.weapon.image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: PetSelectionDelegate {
    func petSelected(_ newPet: PowerPet) {
        pet = newPet
    }
}
