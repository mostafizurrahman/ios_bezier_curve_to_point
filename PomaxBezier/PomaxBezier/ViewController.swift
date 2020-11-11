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
    var drawingSize = CGSize.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        drawingSize = CGSize(width: drawingView.bounds.width * drawingView.contentScaleFactor,
                             height: drawingView.bounds.height * drawingView.contentScaleFactor)
        // Do any additional setup after loading the view.
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIGraphicsBeginImageContext(drawingSize)
        for touch in touches {
            self.draw(point: touch.preciseLocation(in: self.drawingView))
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches {
            self.draw(point: touch.preciseLocation(in: self.view))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            self.draw(point: touch.preciseLocation(in: self.view))
        }
        
        UIGraphicsEndImageContext()
    }
    
    func draw(point:CGPoint){
        if let _context = UIGraphicsGetCurrentContext() {
            _context.addEllipse(in: CGRect.init(origin: point * self.drawingView.contentScaleFactor,
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
}

func *(_ a:CGPoint, _ b:CGFloat)->CGPoint{
    return CGPoint(x: a.x*b - dotSize/2, y: (UIScreen.main.bounds.height - a.y)*b - dotSize/2)
}

