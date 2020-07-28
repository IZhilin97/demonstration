//
//  Created by Иван Жилин on 26.06.2020.
//

import UIKit

@IBDesignable
class CircularChart: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var inited: Bool = false
    
    @IBInspectable var fillColor: UIColor?
    @IBInspectable var innerColor: UIColor?
    @IBInspectable var percent: CGFloat = 0.0 {
        didSet{
            initCircle()
        }
    }
    @IBInspectable var chartLineWidth: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        initCircle()
    }
    
    override var bounds: CGRect {
        didSet {
            initCircle()
        }
    }
    
    func initCircle(){
        if inited {
            self.subviews[2].removeFromSuperview()
            self.subviews[1].removeFromSuperview()
            self.subviews[0].removeFromSuperview()
        }
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        var radius: CGFloat = 0.0
        if self.bounds.width > self.bounds.height {
            radius = self.bounds.height / 2
        }else{
            radius = self.bounds.width / 2
        }
        
        let outerBackground = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.frame.width, height: self.frame.height))
        outerBackground.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)

        let outerBackgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        outerBackgroundPath.lineWidth = 10
        outerBackgroundPath.stroke()
        let outerBackgroundPathMask = CAShapeLayer()
        outerBackgroundPathMask.path = outerBackgroundPath.cgPath
        outerBackground.layer.mask = outerBackgroundPathMask
        outerBackground.layer.masksToBounds = false
        self.insertSubview(outerBackground, at: 0)
        
        
        let outerView = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.frame.width, height: self.frame.height))
        outerView.backgroundColor = fillColor ?? .black
        self.insertSubview(outerView, at: 1)
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle:  ((2 * CGFloat.pi) * CGFloat(percent)) - CGFloat.pi / 2, clockwise: true)
        path.addLine(to: center)
        path.lineWidth = 10
        path.stroke()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        outerView.layer.mask = mask
        outerView.layer.masksToBounds = false
        
        //--------------------------------------
        
        let innerCircle = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.frame.width, height: self.frame.height))
        innerCircle.backgroundColor = innerColor ?? .green


        let innerPath = UIBezierPath(arcCenter: center, radius: radius - chartLineWidth, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        innerPath.lineWidth = 10
        innerPath.stroke()
        let innerMask = CAShapeLayer()
        innerMask.path = innerPath.cgPath
        innerCircle.layer.mask = innerMask
        innerCircle.layer.masksToBounds = false

        self.insertSubview(innerCircle, at: 2)
        inited = true
    }
}
