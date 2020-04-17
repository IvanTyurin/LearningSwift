//
//  PowerPet.swift
//  Learning Swift Part 2
//
//  Created by Ivan Tyurin on 10.04.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

enum Weapon {
    case claws, jaws, paws, cuteEyes
    //кошака-убивака, пёсик-матросик, бурундук, паукан
    var image: UIImage? {
        switch self {
        case .claws:
            guard let img = UIImage(named: "claws.png") else {return nil}
            return img
            
        case .jaws:
            guard let img = UIImage(named: "jaws.png") else {return nil}
            return img
            
        case .paws:
            guard let img = UIImage(named: "paws.png") else {return nil}
            return img
            
        case .cuteEyes:
            guard let img = UIImage(named: "cuteEyes.png") else {return nil}
            return img
        }
    }
}

class PowerPet {
    let name: String
    let description: String
    let iconName: String
    let weapon: Weapon
    
    init(name: String, description: String, iconName: String, weapon: Weapon) {
        self.name = name
        self.description = description
        self.iconName = iconName
        self.weapon = weapon
    }
    
    var icon: UIImage? {
        return UIImage(named: iconName)
    }
}
