import UIKit

@IBDesignable class CounterView: UIView {
  
  private struct Constants {
    static let numberOfGlasses = 8
    static let lineWigth: CGFloat = 4.0
    static let arcWidth: CGFloat = 80
    
    static var halfOfLineWidth: CGFloat {
      return lineWigth / 2
    }
  }
  
  @IBInspectable var counter: Int = 5 {
    didSet {
      if counter <= Constants.numberOfGlasses {
        setNeedsDisplay()
      }
    }
  }
  @IBInspectable var outlineColor: UIColor = UIColor.purple
  @IBInspectable var counterColor: UIColor = UIColor.cyan
  
  override func draw(_ rect: CGRect) {
    let center: CGPoint = CGPoint(
      x: bounds.width / 2,
      y: bounds.height / 2)
    
    let radius: CGFloat = max(bounds.width, bounds.height)
    let startAngle: CGFloat = 3 * .pi / 4
    let endAngle: CGFloat = .pi / 4
    
    let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
    let arcLenghtPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
    let outlineEndAngle = arcLenghtPerGlass * CGFloat(counter) + startAngle
    
    let path = UIBezierPath(
      arcCenter: center,
      radius: radius / 2 - Constants.arcWidth / 2,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: true)
    
    let outlinePath = UIBezierPath(
      arcCenter: center,
      radius: bounds.width / 2 - Constants.halfOfLineWidth,
      startAngle: startAngle,
      endAngle: outlineEndAngle,
      clockwise: true)
    
    outlinePath.addArc(
      withCenter: center,
      radius: bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth,
      startAngle: outlineEndAngle,
      endAngle: startAngle,
      clockwise: false)
    outlinePath.close()
    
    path.lineWidth = Constants.arcWidth
    counterColor.setStroke()
    path.stroke()
    
    outlineColor.setStroke()
    outlinePath.lineWidth = Constants.lineWigth
    outlinePath.stroke()
  }
}
