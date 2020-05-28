//
//  fullScreenImageViewController.swift
//  ImageGallery
//
//  Created by Ivan Tyurin on 13.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import CoreGraphics

class FullScreenImageViewController: UIViewController {
    var photoIndex: Int?
    var panGestureAncor: CGPoint?
    var rotateBaseValue: CGFloat?

    private let photoCollector = PhotoCollector.shared

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = photoIndex {
            imageView.image = photoCollector.getImage(index: index)
        }
    }

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            panGestureAncor = imageView.center
        case .changed:
            let translation = recognizer.translation(in: imageView)
            if let view = recognizer.view {
              view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPoint.zero, in: imageView)
        case .ended:
            if let view = recognizer.view {
                view.center = panGestureAncor ?? CGPoint.zero
            }
        default:
            break
        }
    }

    @IBAction func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        guard let recognizerView = recognizer.view else { return }

        recognizerView.transform = recognizerView.transform.scaledBy(
          x: recognizer.scale,
          y: recognizer.scale
        )

        recognizer.scale = 1
    }

    @IBAction func handleRotate(_ recognizer: UIRotationGestureRecognizer) {
        if let gestureView = recognizer.view {
            gestureView.transform = gestureView.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }

    @IBAction func swipeRecognizer(_ recognizer: UISwipeGestureRecognizer) {
        let cells = photoCollector.arrayOfImagesPreview.count - 1

        switch recognizer.direction {
        case .right:
            if var index = photoIndex, index > 0 {
                index -= 1
                photoIndex = index
                imageView.image = photoCollector.getImage(index: index)
            }
        case .left:
            if var index = photoIndex, index < cells {
                index += 1
                photoIndex = index
                imageView.image = photoCollector.getImage(index: index)
            }
        default:
            break
        }
    }
}
