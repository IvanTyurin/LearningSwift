//
//  MosaicViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 12.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit

class MosaicViewController: UICollectionViewController  {
    let photoCollector = PhotoCollector.shared


    var arrayOfImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        photoCollector.photoAutorization()

        DispatchQueue.global(qos: .userInitiated).async {
            let images = self.photoCollector.getAllImages()
            DispatchQueue.main.async {
                self.arrayOfImages = images
                self.collectionView.reloadData()
            }
        }


        view.backgroundColor = UIColor.blue
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

extension MosaicViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "mosaicCell", for: indexPath) as? MosaicCollectionViewCell
        else { return UICollectionViewCell() }
        imageCell.backgroundColor = UIColor.black
        imageCell.imageView.image = arrayOfImages[indexPath.row]
        return imageCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.5, height: height * 0.5)
    }
//guard let img = photoCollector.getImage() else { return UICollectionViewCell() }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = photoCollector.getImage(index: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FullScreenImageVC") as? FullScreenImageViewController else { return }

        vc.image = image
        self.present(vc, animated: true, completion: nil)
    }
}
