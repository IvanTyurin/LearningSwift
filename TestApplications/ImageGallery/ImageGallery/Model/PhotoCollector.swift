//
//  PhotoCollector.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 12.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import Photos

class PhotoCollector {
    static let shared = PhotoCollector()
    var arrayOfImagesPreview = [UIImage]()

    private init() {
        arrayOfImagesPreview = getAllImages()
    }

    func getAllImages() -> [UIImage] {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let manager = PHImageManager.default()
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
            var array = [UIImage]()

            if fetchResult.count > 0  {
                for i in 0...fetchResult.count - 1 {
                    manager.requestImage(for: fetchResult.object(at: i),
                                         targetSize: CGSize(width: 400, height: 400),
                                         contentMode: .aspectFit,
                                         options: requestOptions()) { (image, _) in
                                            if let image = image {
                                                array.append(image)
                                            }
                    }
                }
            }
            return array
        default:
            return []
        }
    }

    func getImage(index: Int) -> UIImage {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let manager = PHImageManager.default()
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
            var image = UIImage()
            let width = fetchResult.object(at: index).pixelWidth
            let height = fetchResult.object(at: index).pixelHeight

            manager.requestImage(for: fetchResult.object(at: index),
                                 targetSize: CGSize(width: width, height: height),
                                 contentMode: .aspectFill,
                                 options: requestOptions()) { (img, _) in
                                    guard let img = img else { return }
                                    image = img
            }
            return image
        default:
            return UIImage()
        }
    }

    func getHalfQualityImage(index: Int) -> UIImage {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let manager = PHImageManager.default()
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
            var image = UIImage()
            let width = fetchResult.object(at: index).pixelWidth
            let height = fetchResult.object(at: index).pixelHeight

            manager.requestImage(for: fetchResult.object(at: index),
                                 targetSize: CGSize(width: width / 2, height: height / 2),
                                 contentMode: .aspectFill,
                                 options: requestOptions()) { (img, _) in
                                    guard let img = img else { return }
                                    image = img
            }
            return image
        default:
            return UIImage()
        }
    }

    private func fetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return fetchOptions
    }

    private func requestOptions() -> PHImageRequestOptions {
        let requestOptions = PHImageRequestOptions()

        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }

    func photoAutorization() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (_) in }
        default:
            break
        }
    }
}


