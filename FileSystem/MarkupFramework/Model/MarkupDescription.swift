import UIKit

/// Describes a page of markup
public protocol MarkupDescription: NSCoding {
  
  var textColor: UIColor { get set }
  var longDescription: String? { get set }
  var title: String? { get set }
  var textBackgroundColor: UIColor { get set }
  var image: UIImage? { get set }
  var template: String { get }
  
}









