//
//  ThemeSelectionView.swift
//  ping
//
//  Created by Michael Fröhlich on 04.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class ThemeSelectionViewCell: UITableViewCell {
    
    var theme: ThemeProvider? {
        didSet {
            if let theme = theme {
                updateCellContent(theme)
            }
        }
    }
    
    var isSelectedTheme: Bool {
        guard let theme = theme else { return false }
        return type(of: theme) == type(of: Injection.theme.self)
    }
    
    // MARK: Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
        if let theme = theme {
            updateCellContent(theme)
        }
    }
    
    // MARK: Setup
    private func initialSetup() {
        
        backgroundColor = .red
        
//        delegate = self
//
//        borderBottomView = DashedView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 2.0))
//        borderBottomView.dashLength = 15.0
//        borderBottomView.spaceLength = 10.0
//        addSubview(borderBottomView)
//
//        borderBottomView.translatesAutoresizingMaskIntoConstraints = false
//
//        borderBottomViewHeightConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2.0)
//        borderBottomViewBottomConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
//        let leadingConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
//        let trailingConstraint = NSLayoutConstraint(item: borderBottomView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
//
//
//        self.addConstraint(borderBottomViewHeightConstraint)
//        self.addConstraint(borderBottomViewBottomConstraint)
//        self.addConstraint(leadingConstraint)
//        self.addConstraint(trailingConstraint)
        
    }
    
    private func styleView() {
        applyTheme()
    }
    
    private func applyTheme() {
        let theme = Injection.theme
        
        backgroundColor = theme.backgroundColor
        
    }
    
    // MARK: Content Updates
    
    private func updateCellContent(_ pingResponse: ThemeProvider) {
        // TODOr
    }
}
