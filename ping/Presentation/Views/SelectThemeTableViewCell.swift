//
//  SelectThemeTableViewCell.swift
//  ping
//
//  Created by Michael Fröhlich on 06.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class SelectThemeTableViewCell: UITableViewCell {
    
    var theme: AppTheme? {
        didSet {
            if let theme = theme {
                updateCellContent(theme)
            }
        }
    }
    var isSelectedTheme: Bool = false {
        didSet {
            checkmarkImageView?.alpha = isSelectedTheme ? 1.0 : 0.0
        }
    }
    
    @IBOutlet var themeNameLabel: UILabel!
    @IBOutlet var checkmarkImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
        if let theme = theme {
            updateCellContent(theme)
        }
    }
    
    private func styleView() {
        checkmarkImageView?.alpha = isSelectedTheme ? 1.0 : 0.0
        applyTheme()
    }
    
    private func applyTheme() {
        let theme = Injection.themeRepository.selectedTheme
        
        backgroundColor = theme.backgroundColor
        
        themeNameLabel.textColor = theme.textColor
        
        if let image = checkmarkImageView.image {
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            checkmarkImageView.image = coloredImage
            checkmarkImageView.tintColor = theme.textColor
        }
    }
    
    private func updateCellContent(_ theme: AppTheme) {
        themeNameLabel?.text = theme.name
    }
    
    public func reloadCellContent() {
        if let theme = theme {
            updateCellContent(theme)
        }
    }
}
