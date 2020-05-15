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
    var image = UIImage()
    var panGestureAncor: CGPoint?
    var rotateBaseValue: CGFloat?

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        imageView.image = image
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




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
