/// Copyright (c) 2019 Razeware LLC

import UIKit

class ViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet weak var cloud1ImageView: UIImageView!
  @IBOutlet weak var cloud2ImageView: UIImageView!
  @IBOutlet weak var cloud3ImageView: UIImageView!
  @IBOutlet weak var cloud4ImageView: UIImageView!
  @IBOutlet weak var cloud1LeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cloud2TrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cloud3TrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var cloud4LeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var headerLabelCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var loginButtonCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordTextFieldCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var usernameTextFieldCenterConstraint: NSLayoutConstraint!

  
// MARK: - Variables And Properties
  let label = UILabel()
  let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
  let spinner = UIActivityIndicatorView(style: .large)
  let status = UIImageView(image: UIImage(named: "banner"))

  var statusPosition = CGPoint.zero

  
// MARK: - View Controller
  override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)

    headerLabelCenterConstraint.constant -= view.bounds.width
    usernameTextFieldCenterConstraint.constant -= view.bounds.width
    passwordTextFieldCenterConstraint.constant -= view.bounds.width
   }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    headerLabelCenterConstraint.constant = 0
    UIView.animate(withDuration: 0.5) {
      [weak self] in self?.view.layoutIfNeeded()
    }
    
    usernameTextFieldCenterConstraint.constant = 0
    UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
      [weak self] in self?.view.layoutIfNeeded()
    }, completion: nil)
    
    passwordTextFieldCenterConstraint.constant = 0
    UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: {
      [weak self] in self?.view.layoutIfNeeded()
    }, completion: nil)
    
    UIView.animate(withDuration: 1.0, delay: 1.2, options: [.curveEaseInOut, .repeat, .autoreverse] , animations: {
      [weak self] in self?.loginButton.backgroundColor = .systemYellow
    }, completion: nil)
    
    animatedClouds()
   }

   override func viewDidLoad() {
     super.viewDidLoad()

     setUpUI()
   }
 
  
// MARK: - Private Methods
  private func setUpUI() {
    loginButton.layer.cornerRadius = 8.0
    loginButton.layer.masksToBounds = true

    spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
    spinner.startAnimating()
    spinner.alpha = 0.0
    loginButton.addSubview(spinner)

    status.isHidden = true
    status.center = loginButton.center
    view.addSubview(status)

    label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
    label.font = UIFont(name: "HelveticaNeue", size: 18.0)
    label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
    label.textAlignment = .center
    status.addSubview(label)
  }

  private func animatedClouds() {
    let options: UIView.AnimationOptions = [.curveEaseInOut, .repeat, .autoreverse]
    
    UIView.animate(withDuration: 2.9, delay: 0, options: options, animations: {
      [weak self] in
        self?.cloud1ImageView.frame.size.height *= 1.18
        self?.cloud1ImageView.frame.size.width *= 1.18
    }, completion: nil)
    
    UIView.animate(withDuration: 3.0, delay: 0.2, options: options, animations: {
      [weak self] in
        self?.cloud2ImageView.frame.size.height *= 1.28
        self?.cloud2ImageView.frame.size.width *= 1.28
    }, completion: nil)
    
    UIView.animate(withDuration: 2.4, delay: 0.1, options: options, animations: {
      [weak self] in
        self?.cloud3ImageView.frame.size.height *= 1.15
        self?.cloud3ImageView.frame.size.width *= 1.15
    }, completion: nil)
    
    UIView.animate(withDuration: 3.2, delay: 0.5, options: options, animations: {
      [weak self] in
        self?.cloud4ImageView.frame.size.height *= 1.23
        self?.cloud4ImageView.frame.size.width *= 1.23
    }, completion: nil)
  }

// MARK: - IBActions

 @IBAction func login() {
   view.endEditing(true)
 }
}


// MARK: - Text Field Delegate
extension ViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextField = textField === usernameTextField ? passwordTextField : usernameTextField
    nextField?.becomeFirstResponder()

    return true
  }
}
