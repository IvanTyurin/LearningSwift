/// Copyright (c) 2017 Razeware LLC

import Foundation
import CryptoSwift

final class AuthController {
  static let serviceName = "FriendvatarsService"

  static var isSignedIn: Bool {
    guard let currentUser = Settings.currentUser else { return false }

    do {
      let password = try KeychainPasswordItem(service: serviceName, account: currentUser.email).readPassword()
      return password.count > 0
    } catch {
      return false
    }
  }

  class func passwordHash(from email: String, password: String) -> String  {
    let salt = "x4vV8bGgqqmQwgCoyXFQj+(o.nUNQhVP7ND"
    return "\(password).\(email).\(salt)".sha256()
  }

  class func signIn(_ user: User, password: String) throws {
    let finalHash = passwordHash(from: user.email, password: password)
    try KeychainPasswordItem(service: serviceName, account: user.email).savePassword(finalHash)
    Settings.currentUser = user

    NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
  }

  class func signOut() throws {
    guard let currentUser = Settings.currentUser else { return }

    try KeychainPasswordItem(service: serviceName, account: currentUser.email).deleteItem()
    Settings.currentUser = nil

    NotificationCenter.default.post(name: .loginStatusChanged, object: nil)
  }
}

extension Notification.Name {
  static let loginStatusChanged = Notification.Name("com.razeware.auth.changed")
}
