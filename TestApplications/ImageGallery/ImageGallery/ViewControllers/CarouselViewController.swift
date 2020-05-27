//
//  CarouselViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 26.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var smallCollectionView: UICollectionView!

    private let photoCollector = PhotoCollector.shared

    private var originalImageSize = CGSize.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollViewSetup()
        smallCollectionView.dataSource = self
        smallCollectionView.delegate = self
    }

    private func scrollViewSetup() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        scrollView.zoomScale = scrollView.minimumZoomScale
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        bigImageView.image = photoCollector.getImage(index: 0)
        recenterImage()
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
        //bigImageView.frame = CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        bigImageView.image = image
        originalImageSize = image.size
        let scaleWidth = bigImageView.bounds.size.width / image.size.width
        let scaleHeight = bigImageView.bounds.size.height / image.size.height
        scrollView.contentSize = CGSize(width: bigImageView.bounds.size.width * scaleWidth, height: bigImageView.bounds.size.height * scaleHeight)
        recenterImage()
    }
}

extension CarouselViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bigImageView
    }

    func recenterImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = bigImageView.bounds.size
        let horizontalSize = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2.0 : 0
        let verticalSize = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2.0 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalSize, left: horizontalSize, bottom: verticalSize, right: horizontalSize)
    }
}
