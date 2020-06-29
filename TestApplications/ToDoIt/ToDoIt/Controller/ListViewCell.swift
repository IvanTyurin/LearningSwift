//
//  ListViewCell.swift
//  ToDoIt
//
//  Created by Ivan Tyurin on 22.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var deadLineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.checkBox.setImage(UIImage(systemName: "circle"), for: .normal)
        checkBox.tintColor = .systemGray3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
