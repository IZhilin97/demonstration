//
//  Created by Иван Жилин on 29.06.2020.
//

import Foundation
import UIKit

class ChartPointView: UIView{
    
    var radius: CGFloat
    
    override func draw(_ rect: CGRect) {
        drawCirclePoint()
        drawLabel()
    }
    
    init(frame: CGRect, radius: CGFloat) {
        self.radius = radius
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.radius = 0.0
        super.init(coder: coder)
    }
    
    func drawLabel(){
        let cornerRadius: CGFloat = 5
        let tailHeight: CGFloat = 5
        let tailWidth: CGFloat = 7
        let tailInset: CGFloat = 7
        
        let containerView = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height - radius))
        containerView.backgroundColor = .blue
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: cornerRadius, y: 0))
        path.addLine(to: CGPoint(x: containerView.bounds.width - cornerRadius, y: 0))
        path.addQuadCurve(to: CGPoint(x: containerView.bounds.width, y: cornerRadius), controlPoint: CGPoint(x: containerView.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: containerView.bounds.width, y: containerView.bounds.height - cornerRadius - tailHeight - tailInset))
        path.addQuadCurve(to: CGPoint(x: containerView.bounds.width - cornerRadius, y: containerView.bounds.height - tailHeight - tailInset), controlPoint: CGPoint(x: containerView.bounds.width, y: containerView.bounds.height - tailHeight - tailInset))
        path.addLine(to: CGPoint(x: containerView.bounds.midX + (tailWidth / 2), y: containerView.bounds.height - tailHeight - tailInset))
        path.addLine(to: CGPoint(x: containerView.bounds.midX, y: containerView.bounds.maxY - tailInset))
        path.addLine(to: CGPoint(x: containerView.bounds.midX - (tailWidth / 2), y: containerView.bounds.maxY - tailHeight - tailInset))
        path.addLine(to: CGPoint(x: cornerRadius, y: containerView.bounds.maxY - tailHeight - tailInset))
        path.addQuadCurve(to: CGPoint(x: 0, y: containerView.bounds.height - cornerRadius - tailHeight - tailInset), controlPoint: CGPoint(x: 0, y: containerView.bounds.height - tailHeight - tailInset))
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint(x: 0, y: 0))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        containerView.layer.mask = mask
        containerView.layer.masksToBounds = false
        
        self.addSubview(containerView)
    }
    
    func drawCirclePoint(){
        let pointView = UIView(frame: CGRect(x: self.bounds.midX - radius / 2, y: self.bounds.maxY - radius, width: radius, height: radius))
        pointView.backgroundColor = .lightGray
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: pointView.bounds.midX, y: pointView.bounds.midY), radius: radius / 2, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        let mask = CAShapeLayer()
        mask.path = circlePath.cgPath
        pointView.layer.mask = mask
        pointView.layer.masksToBounds = false
        self.addSubview(pointView)
        
        let whiteView = UIView(frame: pointView.frame)
        let whiteCirclePath = UIBezierPath(arcCenter: CGPoint(x: pointView.bounds.midX, y: pointView.bounds.midY), radius: (radius / 2) - 1, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        whiteView.backgroundColor = .white
        
        let whiteMask = CAShapeLayer()
        whiteMask.path = whiteCirclePath.cgPath
        whiteView.layer.mask = whiteMask
        whiteView.layer.masksToBounds = false
        self.addSubview(whiteView)
        
        let innerView = UIView(frame: pointView.frame)
        let innerCirclePath = UIBezierPath(arcCenter: CGPoint(x: pointView.bounds.midX, y: pointView.bounds.midY), radius: (radius / 2 < 3) ? (radius / 2) : 3, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        innerView.backgroundColor = .blue
        
        let innerMask = CAShapeLayer()
        innerMask.path = innerCirclePath.cgPath
        innerView.layer.mask = innerMask
        innerView.layer.masksToBounds = false
        self.addSubview(innerView)
    }
}
