//
//  DrawingView.swift
//  PomaxBezier
//
//  Created by Mostafizur Rahman on 11/11/20.
//

import Foundation
import UIKit

class DrawingView:UIView {
    

    
    var point:CGPoint = .zero{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    var image:CGImage? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        
        
        if let _context = UIGraphicsGetCurrentContext(), let image = self.image {
            _context.draw(image, in: rect)
//            _context.addEllipse(in: CGRect.init(origin: point, size: CGSize(width: 3, height: 3)))
//            _context.drawPath(using: .fill)
//            _context.fillPath(using: CGPathFillRule.winding)
        }
    }
    
}
