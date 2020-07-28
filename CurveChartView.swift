//
//  Created by Иван Жилин on 29.06.2020.
//

import Foundation
import UIKit

@IBDesignable
class CurveChartView: UIView {
    
    let horizontalInset: CGFloat = 25
    let verticalInset: CGFloat = 20
    let chartLineWidth: CGFloat = 2
    let gradientLayer = CAGradientLayer()

    var pointsArr: [CGPoint] = []
    
    // test data
    var data: [CGFloat] = [51, 35, 62, 100, 84, 90] {
        didSet {
            setNeedsDisplay()
        }
    }

    func coordYFor(index: Int) -> CGFloat {
        return (bounds.height - 20) - ((bounds.height - 20) - verticalInset) * (data[index] / (data.max() ?? 0))
    }

    override func draw(_ rect: CGRect) {

        let path = quadCurvedPath()
        
        let chartView = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height - 20))
        
        gradientLayer.frame = CGRect(x: chartView.bounds.minX, y: chartView.bounds.minY + chartLineWidth / 2, width: chartView.bounds.width, height: chartView.bounds.height)
        gradientLayer.colors = chartGradientColors
        chartView.layer.insertSublayer(gradientLayer, at: 0)
        self.insertSubview(chartView, at: 0)
        
        path.lineWidth = chartLineWidth
        UIColor.blue.setStroke()
        path.stroke()
        
        path.addLine(to: CGPoint(x: chartView.bounds.width - horizontalInset, y: chartView.bounds.height))
        path.addLine(to: CGPoint(x: horizontalInset, y: chartView.bounds.height))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        chartView.layer.mask = mask
        chartView.layer.masksToBounds = false
        
        for i in 0..<pointsArr.count {
            self.addSubview(getPointView(point: pointsArr[i], data: data[i]))
        }
    }
    

    func quadCurvedPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        let step = bounds.width / CGFloat(data.count - 1) - (horizontalInset /  CGFloat(data.count - 1))

        var p1 = CGPoint(x: horizontalInset, y: coordYFor(index: 0))
        path.move(to: p1)

        pointsArr.append(p1)
        
        if (data.count == 2) {
            path.addLine(to: CGPoint(x: p1.x + step, y: coordYFor(index: 1)))
            return path
        }

        var oldControlP: CGPoint?

        for i in 1..<data.count {
            let p2 = CGPoint(x: step * CGFloat(i), y: coordYFor(index: i))
            pointsArr.append(p2)
            var p3: CGPoint?
            if i < data.count - 1 {
                p3 = CGPoint(x: step * CGFloat(i + 1), y: coordYFor(index: i + 1))
            }

            let newControlP = controlPointForPoints(p1: p1, p2: p2, next: p3)

            path.addCurve(to: p2, controlPoint1: oldControlP ?? p1, controlPoint2: newControlP ?? p2)

            p1 = p2
            oldControlP = antipodalFor(point: newControlP, center: p2)
        }
        return path;
    }

    func antipodalFor(point: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let p1 = point, let center = center else {
            return nil
        }
        let newX = 2 * center.x - p1.x
        let diffY = abs(p1.y - center.y)
        let newY = center.y + diffY * (p1.y < center.y ? 1 : -1)

        return CGPoint(x: newX, y: newY)
    }

    func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2);
    }

    func controlPointForPoints(p1: CGPoint, p2: CGPoint, next p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else {
            return nil
        }

        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)

        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: antipodalFor(point: rightMidPoint, center: p2)!)

        if p1.y.between(a: p2.y, b: controlPoint.y) {
            controlPoint.y = p1.y
        } else if p2.y.between(a: p1.y, b: controlPoint.y) {
            controlPoint.y = p2.y
        }


        let imaginContol = antipodalFor(point: controlPoint, center: p2)!
        if p2.y.between(a: p3.y, b: imaginContol.y) {
            controlPoint.y = p2.y
        }
        if p3.y.between(a: p2.y, b: imaginContol.y) {
            let diffY = abs(p2.y - p3.y)
            controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
        }

        controlPoint.x += (p2.x - p1.x) * 0.1

        return controlPoint
    }

    func drawPoint(point: CGPoint) {
        let bigRadius: CGFloat = 8
        let circlePath = UIBezierPath(arcCenter: point, radius: bigRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        UIColor.green.setFill()
        circlePath.fill()
    }
    
    func getPointView(point: CGPoint, data: CGFloat) -> UIView{
        let bigRadius: CGFloat = 14
        let viewHeight: CGFloat = 50
        let viewWidth = bigRadius * 3
        
        let view = ChartPointView(frame: CGRect(x: point.x - viewWidth / 2, y: point.y - viewHeight + bigRadius / 2, width: viewWidth, height: viewHeight), radius: bigRadius)
        view.backgroundColor = .clear
        
        return view
    }
}

extension CGFloat {
    func between(a: CGFloat, b: CGFloat) -> Bool {
        return self >= Swift.min(a, b) && self <= Swift.max(a, b)
    }
}
