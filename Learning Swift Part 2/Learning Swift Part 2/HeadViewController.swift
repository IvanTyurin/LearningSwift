//
//  HeadViewController.swift
//  Learning Swift Part 2
//
//  Created by Ivan Tyurin on 10.04.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class HeadViewController: UITableViewController {
    
    let pets = [
        PowerPet(name: "Кошака-Убивака", description: "Замуррлыкательно опасный тип животных-наёмников. Особо опасна ночью или в лучах солнечного зайчика.", iconName: "badCat.png", weapon: .claws),
        PowerPet(name: "Пёсик-матросик", description: "Пёсики кусают за заднее место. НЕ стоит поворачиваться к ним спиной. Особо опасен в моменты детектирования косточки.", iconName: "badDog.png", weapon: .jaws),
        PowerPet(name: "Бурундучёк", description: "Прикидывается, что его интересуют только орехи. Но это не так. Чёрный пояс по кунг-фу. Любимый приём - скидыщь, как у Панды", iconName: "badChipmunk.png", weapon: .paws),
        PowerPet(name: "Павукан", description: "Чёрная свекровь. Убивает за один борщ. Лучше не обедать в ресторане у этой паучихи. Особо опасна на банкетах.", iconName: "badSpider.png", weapon: .cuteEyes)
    ]
  
    weak var delegate: PetSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pets.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let pet = pets[indexPath.row]
        
        cell.textLabel?.text = pet.name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = pets[indexPath.row]
        delegate?.petSelected(selectedPet)
        guard let detailViewController = delegate as? DetailViewController,
            let detailNavigationController = detailViewController.navigationController
        else { return }
        splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
    }

}

protocol PetSelectionDelegate: class {
    func petSelected(_ newPet: PowerPet)
}
