//
//  PhotoCollector.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 12.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoCollector {
    static let shared = PhotoCollector()

    private init() {}

    func getAllImages() -> [UIImage] {
        let manager = PHImageManager.default()
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        var arrayOfImages = [UIImage]()

        for i in 0...fetchResult.count - 1 {
            manager.requestImage(for: fetchResult.object(at: i),
                                 targetSize: CGSize(width: 100, height: 100),
                                 contentMode: .aspectFit,
                                 options: requestOptions()) { (image, _) in
                                    if let image = image {
                                        arrayOfImages.append(image)
                                    }
            }
        }
        return arrayOfImages
    }

    func getImage(index: Int) -> UIImage {
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


