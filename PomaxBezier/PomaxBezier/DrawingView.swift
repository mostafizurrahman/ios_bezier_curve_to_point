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
    
    
    override func draw(_ rect: CGRect) {
        if let _context = UIGraphicsGetCurrentContext() {
            
        }
    }
    
}
