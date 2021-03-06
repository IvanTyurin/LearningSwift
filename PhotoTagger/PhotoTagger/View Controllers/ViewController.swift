/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SwiftyJSON
import Alamofire

struct PersonalPhoto {
    var name: String
    var confidence: Double
}

class ViewController: UIViewController {

  // MARK: - IBOutlets
  @IBOutlet var takePictureButton: UIButton!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var progressView: UIProgressView!
  @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

  // MARK: - Properties
  private var tags: [String]?
  private var colors: [PhotoColor]?

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      takePictureButton.setTitle("Select Photo", for: .normal)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    imageView.image = nil
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "ShowResults",
      let controller = segue.destination as? TagsColorsViewController {
      controller.tags = tags
      controller.colors = colors
    }
  }

  // MARK: - IBActions
  @IBAction func takePicture(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = false

    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    } else {
      picker.sourceType = .photoLibrary
      picker.modalPresentationStyle = .fullScreen
    }

    present(picker, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
      print("Info did not have the required UIImage for the Original Image")
      dismiss(animated: true)
      return
    }

    imageView.image = image

    takePictureButton.isHidden = true
    progressView.progress = 0.0
    progressView.isHidden = false
    activityIndicatorView.startAnimating()

    upload(image: image,
           progressCompletion: { [weak self] percent in
              self?.progressView.setProgress(percent, animated: true)
        },
           completion: { [weak self] tags, colors in
              self?.takePictureButton.isHidden = false
              self?.progressView.isHidden = true
              self?.activityIndicatorView.stopAnimating()

              self?.tags = tags
              self?.colors = colors

              self?.performSegue(withIdentifier: "ShowResults", sender: self)
    })

    dismiss(animated: true)
  }
}

extension ViewController {
  func upload(image: UIImage,
              progressCompletion: @escaping (_ percent: Float) -> Void,
              completion: @escaping (_ tags: [String]?, _ colors: [PhotoColor]?) -> Void) {
    guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
      print("Could't get jpeg representantion of UIImage")
      return
    }

    let authorizationHeader = "Basic YWNjX2U0ZmI5ODgyODM1YTExZTpiNWNkMDUwMjUyNzFkNmNkNjE2ZmI3YTg0Zjk0YTYxMg=="

    Alamofire.upload(multipartFormData: { multipartFromData in
      multipartFromData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
    },
                     to: "https://api.imagga.com/v2/categories/personal_photos",
                     headers: ["Authorization": authorizationHeader,
                               "accept": "application/json"],
                     encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                          upload.uploadProgress { progress in
                            progressCompletion(Float(progress.fractionCompleted))
                          }
                          upload.validate()
                          upload.responseJSON { response in
                            guard response.result.isSuccess, let value = response.result.value else {
                                print("Error while uploading file: \(String(describing: response.result.error))")
                                completion(nil, nil)
                                return
                            }

                            let tags = JSON(value)["result"]["categories"].array?.map { json in
                              json["name"]["en"].stringValue
                            }

                            completion(tags, nil)
                          }
                      case .failure(let encodingError):
                        print(encodingError)
                      }
    })
  }
}
