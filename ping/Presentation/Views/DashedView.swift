//
//  DashedView.swift
//  tip
//
//  Created by Michael Fröhlich on 08.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

@IBDesignable
class DashedView: UIView {
    
    @IBInspectable var dashLength: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var spaceLength: CGFloat = 10.0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var dashColor: UIColor = .black {
        didSet {
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func reset() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    private func setup() {
        reset()
        
        let width = self.bounds.width
        var currentPosition = CGPoint.zero
        
        var dash = true
        while currentPosition.x < width {
            if dash {
                let length = dashLength + currentPosition.x < width ? dashLength : width - currentPosition.x
                let view = UIView(frame: CGRect(x: currentPosition.x, y: 0, width: length, height: bounds.height))
                view.backgroundColor = dashColor
                addSubview(view)
                currentPosition.x += length
            } else {
                let length = spaceLength + currentPosition.x < width ? spaceLength : width - currentPosition.x
                let view = UIView(frame: CGRect(x: currentPosition.x, y: 0, width: length, height: bounds.height))
                view.backgroundColor = backgroundColor
                addSubview(view)
                currentPosition.x += length
            }
            dash = !dash
        }
        
    }

}


