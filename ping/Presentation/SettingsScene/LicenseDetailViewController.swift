//
//  LicenseDetailViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class LicenseDetailViewController: UIViewController {
    
    var license: License? {
        didSet {
            updateContent()
        }
    }
    
    @IBOutlet var licenseTitleLabel: UILabel!
    @IBOutlet var licenseUrlTextView: UITextView!
    @IBOutlet var licenseTextView: UITextView!
    @IBOutlet var licenseUrlTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        updateContent()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        licenseUrlTextViewHeightConstraint.constant = licenseUrlTextView.intrinsicContentSize.height
        licenseTextView?.setContentOffset(.zero, animated: false)
        
        super.viewWillLayoutSubviews()
    }
    
    func applyTheme() {
        let theme = Injection.theme
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        
        view.backgroundColor = theme.backgroundColor
        licenseTitleLabel.textColor = theme.textColor
        licenseUrlTextView.textColor = theme.textColor
        licenseUrlTextView.tintColor = theme.tintColor
        licenseTextView.textColor = theme.textColor
        
    }
    
    func updateContent() {
        guard let license = license else {
            return
        }
        
        
        title = license.title
        
        licenseTitleLabel?.text = license.title
        licenseUrlTextView?.text = license.url
        licenseTextView?.text = license.license
        
        licenseTextView?.setContentOffset(.zero, animated: false)
    }
    
}

