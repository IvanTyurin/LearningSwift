//
//  ViewController.swift
//  AlamofireTestApp
//
//  Created by Ivan Tyurin on 06.05.2020.
//  Copyright © 2020 Ivan Tyurin. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        progressView.progress = 0.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        AF.request("http://jsonplaceholder.typicode.com/posts").responseJSON { responseJSON in
//            guard let statusCode = responseJSON.response?.statusCode else { return }
//            print("statusCode: ", statusCode)
//
//            if (200..<300).contains(statusCode) {
//                let value = responseJSON.value
//                print("value: ", value ?? "nil")
//            } else {
//                let error = responseJSON.error
//                print("error: ", error ?? "nil")
//            }
//        }


//        AF.request("http://jsonplaceholder.typicode.com/posts").validate().responseJSON { responseJSON in
//            switch responseJSON.result {
//            case .success:
//                guard let jsonArray = responseJSON.value as? [[String: Any]] else { return }
//
//                var posts: [Post] = []
//
//                for jsonObject in jsonArray {
//                    guard let post = Post(json: jsonObject) else { return }
//                    posts.append(post)
//                }
//
//                print(posts[4])
//
//            case .failure(let error):
//                print(error)
//            }
//        }

        AF.request("http://jsonplaceholder.typicode.com/posts").validate().responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let value):
                guard let posts = Post.getArray(from: value) else { return }
                print(posts[8])

            case .failure(let error):
                print(error)
            }
        }

        AF.request("https://images.pexels.com/photos/1471294/pexels-photo-1471294.jpeg").validate().downloadProgress { progress in
            self.progressView.progress = Float(progress.fractionCompleted)

            print("totalUnitCount:\n", progress.totalUnitCount)
            print("completedUnitCount:\n", progress.completedUnitCount)
            print("fractionCompleted:\n", progress.fractionCompleted)
            print("localizedDescription:\n", progress.localizedDescription ?? "nil")
            print("---------------------------------------------")
        }
        .response { response in
            guard
                let data = response.data,
                let image = UIImage(data: data)
                else { return }
            self.imageView.image = image
        }

        print("viewDidLoad ended")
    }


}

