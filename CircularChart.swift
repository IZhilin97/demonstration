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
    let outerView: UIView = UIView()
    let innerCircle: UIView = UIView()
    let outerBackground: UIView = UIView()
    
    @IBInspectable var fillColor: UIColor?
    @IBInspectable var innerColor: UIColor?
    @IBInspectable var percent: CGFloat = 0.0 {
        didSet{
            setPaths()
        }
    }
    @IBInspectable var chartLineWidth: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCircle()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
//        initCircle()
    }
    
    override var bounds: CGRect {
        didSet {
            setPaths()
        }
    }
    
    func setPaths(){
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        
        var radius: CGFloat = 0.0
        if self.bounds.width > self.bounds.height {
            radius = self.bounds.height / 2
        }else{
            radius = self.bounds.width / 2
        }
        
        let outerBackgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        outerBackgroundPath.lineWidth = 10
        outerBackgroundPath.stroke()
        let outerBackgroundPathMask = CAShapeLayer()
        outerBackgroundPathMask.path = outerBackgroundPath.cgPath
        outerBackground.layer.mask = outerBackgroundPathMask
        outerBackground.layer.masksToBounds = false
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle:  ((2 * CGFloat.pi) * CGFloat(percent)) - CGFloat.pi / 2, clockwise: true)
        path.addLine(to: center)
        path.lineWidth = 10
        path.stroke()
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        outerView.layer.mask = mask
        outerView.layer.masksToBounds = false
        
        let innerPath = UIBezierPath(arcCenter: center, radius: radius - chartLineWidth, startAngle: -CGFloat.pi / 2, endAngle:  2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        innerPath.lineWidth = 10
        innerPath.stroke()
        let innerMask = CAShapeLayer()
        innerMask.path = innerPath.cgPath
        innerCircle.layer.mask = innerMask
        innerCircle.layer.masksToBounds = false
    }
    
    func initCircle(){
        outerBackground.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        outerBackground.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(outerBackground)
        
        outerBackground.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        outerBackground.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        outerBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        outerBackground.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        outerView.backgroundColor = fillColor ?? .black
        outerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(outerView)
        
        outerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        outerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        outerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        outerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        innerCircle.backgroundColor = innerColor ?? .green
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(innerCircle, at: 2)
        
        innerCircle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        innerCircle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        innerCircle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        innerCircle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        setPaths()
        layoutIfNeeded()
    }
}
