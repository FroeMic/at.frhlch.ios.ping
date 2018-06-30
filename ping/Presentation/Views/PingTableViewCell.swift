//
//  PingTableViewCell.swift
//  ping
//
//  Created by Michael Fröhlich on 13.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class PingTableViewCell: UITableViewCell {
    
    var pingResponse: PingResult? {
        didSet {
            if let pingResponse = pingResponse {
                updateCellContent(pingResponse)
            }
        }
    }
    
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var msLabel: UILabel!
    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var hostLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleView()
        if let pingResponse = pingResponse {
            updateCellContent(pingResponse)
        }
    }
    
    private func styleView() {
        backgroundColor = .black
        selectionStyle = .none
        
        let primaryFont = UIFont(name: "Menlo-Bold", size: 13.0)
        let secondaryFont = UIFont(name: "Menlo", size: 10.0)
        
        msLabel.textColor = .white
        msLabel.font = primaryFont
        msLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.font = secondaryFont
        placeholderLabel.adjustsFontSizeToFitWidth = true
        placeholderLabel.text = " "
        hostLabel.textColor = .white
        hostLabel.font = primaryFont
        hostLabel.adjustsFontSizeToFitWidth = true
        detailLabel.textColor = .white
        detailLabel.font = secondaryFont
        detailLabel.adjustsFontSizeToFitWidth = true
        
        statusImageView.contentMode = .scaleAspectFit
    }
    
    private func updateCellContent(_ pingResponse: PingResult) {

        
        if pingResponse.status == .failure && pingResponse.host == "" {
            // Shows a message to the user that the ping was terminated.
            hostLabel?.text = pingResponse.ip
            detailLabel?.text = ""
            msLabel?.text = ""
            statusImageView?.image = UIImage(named: "ic_ping_fail")
        } else if let error = pingResponse.error {
            hostLabel?.text = pingResponse.ip 
            if error == .failedToResolveHost {
                detailLabel?.text = error.localizedDescription
            } else {
                detailLabel?.text = error.localizedDescription + String(format: " for seq=%d", pingResponse.sequence)
            }
            msLabel?.text = pingResponse.timeInMs > 0 ?  String(format: "%.2f ms", pingResponse.timeInMs) : ""
            statusImageView?.image = UIImage(named: "ic_ping_fail")
        } else {
            hostLabel?.text = pingResponse.ip
            detailLabel?.text = String(format: "seq=%d ttl=%d bytes=%d",
                                      pingResponse.sequence,
                                      pingResponse.ttl,
                                      pingResponse.sizeInBytes)
            msLabel?.text = String(format: "%.2f ms", pingResponse.timeInMs)
            statusImageView?.image = UIImage(named: "ic_ping_success")
        }
    }
    
    public func reloadCellContent() {
        if let pingResponse = pingResponse {
            updateCellContent(pingResponse)
        }
    }
}
