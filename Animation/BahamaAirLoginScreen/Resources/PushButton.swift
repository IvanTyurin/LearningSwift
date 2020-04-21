
import UIKit
@IBDesignable

class PushButton: UIButton {
  @IBInspectable var fillColor: UIColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
  @IBInspectable var strokeColor: UIColor = UIColor.magenta
  @IBInspectable var isAddButton: Bool = true
  
  private struct Constaints {
    static let plusLineWidth: CGFloat = 4.0
    static let plusButtonScale: CGFloat = 0.4
    static let halfPointShift: CGFloat = 0.5
  }
  
  private var halfWidth: CGFloat {
    return bounds.width / 2
  }

  private var halfHeight: CGFloat {
    return bounds.height / 2
  }
  
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath(ovalIn: rect)
    fillColor.setFill()
    path.fill()
    
    let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constaints.plusButtonScale
    let halfPlusWidth = plusWidth / 2
    let plusPath = UIBezierPath()
    
    plusPath.lineWidth = Constaints.plusLineWidth
    plusPath.move(to: CGPoint(
      x: halfWidth - halfPlusWidth,
      y: halfHeight))
    plusPath.addLine(to: CGPoint(
      x: halfHeight + halfPlusWidth,
      y: halfHeight))
    
    if isAddButton {
      plusPath.move(to: CGPoint(
        x: halfWidth,
        y: halfHeight - halfPlusWidth))
      plusPath.addLine(to: CGPoint(
        x: halfWidth,
        y: halfHeight + halfPlusWidth))
    }
    
    strokeColor.setStroke()
    plusPath.stroke()
  }
}
