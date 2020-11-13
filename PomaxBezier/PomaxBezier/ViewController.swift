//
//  ViewController.swift
//  PomaxBezier
//
//  Created by Mostafizur Rahman on 11/11/20.
//

import UIKit
let dotSize:CGFloat = 12
class ViewController: UIViewController {

    
    @IBOutlet weak var drawingView: DrawingView!
    var touchPoints:[CGPoint] = []
    var drawingSize = CGSize.zero
    var scalFactor:CGFloat = UIScreen.main.scale
    var counter = 0
    var points:[CGPoint] = Array.init(repeating: .zero, count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.scalFactor = drawingView.contentScaleFactor
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.drawingView.setNeedsDisplay()
        drawingSize = CGSize(width: drawingView.bounds.width * self.scalFactor,
                             height: drawingView.bounds.height * self.scalFactor)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.counter = 0
        UIGraphicsBeginImageContext(drawingSize)
        if let _context = UIGraphicsGetCurrentContext() {
            UIColor.red.setFill()
            _context.fill(CGRect(origin: .zero, size: drawingSize))
            UIColor.black.setFill()
        }
        for touch in touches {
            let _point = touch.preciseLocation(in: self.drawingView)
//            self.points[self.counter] = CGPoint(x: _point.x * self.scalFactor,
//                                                y: (drawingView.bounds.height - _point.y)
//                                                    * self.scalFactor)
            self.points[self.counter] = CGPoint(x: _point.x,
                                                y: (drawingView.bounds.height - _point.y))
            break
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            self.draw(inPoint: touch.preciseLocation(in: self.drawingView))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            self.draw(inPoint: touch.preciseLocation(in: self.drawingView))
        }
        
        UIGraphicsEndImageContext()
    }
    
    func draw(inPoint:CGPoint){
        self.counter += 1
//        self.points[self.counter] = CGPoint(x: inPoint.x * self.scalFactor,
//                                            y: (drawingView.bounds.height - inPoint.y) * self.scalFactor)
        
        self.points[self.counter] = CGPoint(x: inPoint.x ,
                                            y: (drawingView.bounds.height - inPoint.y))
        if self.counter == 4 {
            self.points[3] = CGPoint(x: (self.points[2].x + self.points[4].x)/2.0,
                                     y: (self.points[2].y + self.points[4].y)/2.0)
            let _xs = [points[0].x, points[1].x, points[2].x, points[3].x]
            let _ys = [points[0].y, points[1].y, points[2].y, points[3].y]
            for i in stride(from: 0.1, to: 1.0, by: Double.Stride(0.1)){
                let _x = self.makeBezier(t: CGFloat(i), points: _xs)
                let _y = self.makeBezier(t: CGFloat(i), points: _ys)
            
            ///MARK: DRAW USING BEZIER PATH
//                let path = UIBezierPath()
//                path.move(to: self.points[0])
//                path.addCurve(to: self.points[3], controlPoint1: self.points[1], controlPoint2: self.points[2])
//                if let _context = UIGraphicsGetCurrentContext() {
//                    _context.addPath(path.cgPath)
//                    _context.drawPath(using: .stroke)
//                    _context.strokePath()
//                    if let image = _context.makeImage() {
//                        self.drawingView.image = image
//                    }
//                }
                ///MARK: END DRAW USING BEZIER PATH
            
            
                if let _context = UIGraphicsGetCurrentContext() {
                    _context.addEllipse(in: CGRect.init(origin: CGPoint(x: _x, y: _y) * self.drawingView.contentScaleFactor,
                                                        size: CGSize(width: dotSize, height: dotSize)))

                    _context.drawPath(using: .fill)
                    _context.fillPath()
                    if let image = _context.makeImage() {
                        self.drawingView.image = image
                    }
                }
                
            }
            
            self.points[0] = self.points[3]
            self.points[1] = self.points[4]
            self.counter = 1
        }
        return
        
        
        
        
        self.touchPoints.append(inPoint)
        self.counter += 1
        if self.counter < 3 {
            return
        }
        self.counter = 0
        let len:CGFloat = self.getDistance()
        let factor:Float = Float(0.1/len)
        let _xs = self.touchPoints.getArray()
        let _ys = self.touchPoints.getArray(isX: false)
        for i in stride(from: 0.1, to: 1.0, by: Double.Stride(factor)){
            let _x = self.makeBazier1(t: CGFloat(i), points: _xs)
            let _y = self.makeBazier1(t: CGFloat(i), points: _ys)
            if let _context = UIGraphicsGetCurrentContext() {
                _context.addEllipse(in: CGRect.init(origin: CGPoint(x: _x, y: _y) ,
                                                    size: CGSize(width: dotSize, height: dotSize)))
    //            _context.move(to: CGPoint(x: 0, y: <#T##CGFloat#>))
                _context.drawPath(using: .fill)
                _context.fillPath()
    //            _context.fillPath(using: CGPathFillRule.winding)
                if let image = _context.makeImage() {
                    self.drawingView.image = image
                }
            }
        }
        let _value  = self.touchPoints[self.touchPoints.count - 1]
        self.touchPoints[self.touchPoints.count - 1] = self.touchPoints[self.touchPoints.count - 3]
        self.touchPoints[self.touchPoints.count - 3] = _value
        
    }
    
    func makeBezier(t:CGFloat, points:[CGFloat])->CGFloat {
      let t2 = t * t
      let t3 = t2 * t
      let mt = 1-t
      let mt2 = mt * mt
      let mt3 = mt2 * mt
      return points[0]*mt3 + 3*points[1]*mt2*t + 3*points[2]*mt*t2 + points[3]*t3
    }
    
    func makeBazier1(t:CGFloat, points:[CGFloat]) ->CGFloat {
        let t2 = t * t
        let mt = 1-t
        let mt2 = mt * mt
        return points[0]*mt2 + points[1]*2*mt*t + points[2]*t2
    }
    
    func getDistance() -> CGFloat {
    
        let _len = self.touchPoints.count
        var _x = self.touchPoints[_len - 3].x - self.touchPoints[_len - 1].x
        _x *= _x
        var _y = self.touchPoints[_len - 3].y - self.touchPoints[_len - 1].y
        _y *= _y
        return sqrt(_x + _y)
        
    }
}

func *(_ a:CGPoint, _ b:CGFloat)->CGPoint{
    return CGPoint(x: a.x * b - dotSize / 2, y: ( a.y) * b - dotSize / 2)
}

extension Array where Iterator.Element == CGPoint {
    
    func getArray(isX:Bool = true) -> [CGFloat]{
        var _data = [CGFloat]()
        if isX {
            for i in stride(from: self.count - 3, to: self.count, by: 1) {
                _data.append(self[i].x)
            }
        } else {
            for i in stride(from: self.count - 3, to: self.count , by: 1) {
                _data.append(self[i].y)
            }
        }
        return _data
    }
}

