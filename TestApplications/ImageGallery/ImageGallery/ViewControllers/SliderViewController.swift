//
//  SliderViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 17.06.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private let photoCollector = PhotoCollector.shared
    private let cellScale: CGFloat = 0.8

    override func viewDidLoad() {
        super.viewDidLoad()

        contentSetup()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func contentSetup() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = screenSize.width * cellScale
        let cellHeight = screenSize.height * cellScale
        let insertX = (view.bounds.width - cellWidth) / 2.0
        let insertY = (view.bounds.height - cellHeight) / 2.0

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = CGFloat(20)
        collectionView.contentInset = UIEdgeInsets(top: insertY, left: insertX, bottom: insertY, right: insertX)
    }
}

extension SliderViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollector.arrayOfImagesPreview.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as? SliderCollectionViewCell
        else { return UICollectionViewCell()}

        cell.imageView.image = photoCollector.getHalfQualityImage(index: indexPath.row)
    
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthPlusSpacing = layout.itemSize.width + layout.minimumLineSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthPlusSpacing
        let roundedIndex = round(index)

        offset = CGPoint(x: roundedIndex * cellWidthPlusSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
