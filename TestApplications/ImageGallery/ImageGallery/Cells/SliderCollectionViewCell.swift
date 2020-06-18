//
//  SliderCollectionViewCell.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 17.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
}
