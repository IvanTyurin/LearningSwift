//
//  CarouselCollectionViewCell.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 26.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 4
    }
}
