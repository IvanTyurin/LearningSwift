//
//  CarouselViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 26.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {
    private let photoCollector = PhotoCollector.shared

    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var smallCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        smallCollectionView.dataSource = self
        smallCollectionView.delegate = self
    }
}

extension CarouselViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollector.arrayOfImagesPreview.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = smallCollectionView.dequeueReusableCell(withReuseIdentifier: "carouselCell", for: indexPath) as? CarouselCollectionViewCell
        else { return UICollectionViewCell() }
        cell.imageView.image = photoCollector.arrayOfImagesPreview[indexPath.row]
        cell.backgroundColor = UIColor.gray
        return cell
    }
}

extension CarouselViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = photoCollector.getImage(index: indexPath.row)
        bigImageView.image = image
    }
}
