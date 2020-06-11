//
//  MosaicViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 12.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class MosaicViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private let photoCollector = PhotoCollector.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollector.photoAutorization()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension MosaicViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollector.arrayOfImagesPreview.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mosaicCell", for: indexPath) as? MosaicCollectionViewCell
        else { return UICollectionViewCell() }
        imageCell.imageView.image = photoCollector.arrayOfImagesPreview[indexPath.row]
        return imageCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullScreenImageViewController else { return }

        vc.photoIndex = indexPath.row
        self.show(vc, sender: self)
    }
}

extension MosaicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = view.frame.width / 3 - ((collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0.0) - 2.5
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}
