//
//  PingTableViewCell.swift
//  ping
//
//  Created by Michael Fröhlich on 13.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class HostTableViewCell: UITableViewCell {
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    var host: Host? {
        didSet {
            if let host = host {
                updateCellContent(host)
            }
        }
    }
    
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
        if let host = host {
            updateCellContent(host)
        }
    }
    
    private func styleView() {
        backgroundColor = .black
        selectionStyle = .none
        
        let primaryFont = UIFont(name: "Menlo-Bold", size: 16.0)
        let secondaryFont = UIFont(name: "Menlo", size: 10.0)

        hostLabel.textColor = .white
        hostLabel.font = primaryFont
        hostLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = secondaryFont
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textColor = .white

        statusImageView?.contentMode = .scaleAspectFit
        
        applyTheme()
    }
    
    private func applyTheme() {
        let theme = Injection.themeRepository.selectedTheme
        
        backgroundColor = theme.backgroundColor
        
        hostLabel.textColor = theme.textColor
        dateLabel.textColor = theme.textColor
    }
    
    private func updateCellContent(_ host: Host) {
        statusImageView?.image = host.success ? UIImage(named: "ic_ping_success") : UIImage(named: "ic_ping_fail")
        hostLabel?.text = host.name
        dateLabel.text = HostTableViewCell.dateFormatter.string(from: host.date)
    }
    
    public func reloadCellContent() {
        if let host = host {
            updateCellContent(host)
        }
    }
}
