//
//  SettingViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 04.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    static let showThemeSegueIdentifier = "showThemeScene"
    static let showConfigurationSegueIdentifier = "showConfigurationScene"
    static let showAcknowledgementSegueIdentifier = "showAcknowledgementScene"
    
    @IBOutlet var themeTableViewCell: UITableViewCell!
    @IBOutlet var themeLabel: UILabel!
    @IBOutlet var selectedThemeLabel: UILabel!
    @IBOutlet var themeChevronImageView: UIImageView!
    
    @IBOutlet var configurationTableViewCell: UITableViewCell!
    @IBOutlet var configurationLabel: UILabel!
    @IBOutlet var configurationChevronImageView: UIImageView!
    
    @IBOutlet var acknowledgmentsTableViewCell: UITableViewCell!
    @IBOutlet var acknowledgmentsLabel: UILabel!
    @IBOutlet var acknowledgmentsChevronImageView: UIImageView!
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func applyTheme() {
        let theme = Injection.theme
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        
        view.backgroundColor = theme.backgroundColor
        
        themeTableViewCell.selectionStyle = .none
        themeTableViewCell.backgroundColor = theme.backgroundColor
        themeLabel.textColor = theme.textColor
        
        selectedThemeLabel.text = Injection.theme.name
        selectedThemeLabel.textColor = theme.textColor.withAlphaComponent(0.7)
        
        if let image = themeChevronImageView.image {
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            themeChevronImageView.image = coloredImage
            themeChevronImageView.tintColor = theme.textColor
        }
        
        configurationTableViewCell.selectionStyle = .none
        configurationTableViewCell.backgroundColor = theme.backgroundColor
        configurationLabel.textColor = theme.textColor
     
        if let image = configurationChevronImageView.image {
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            configurationChevronImageView.image = coloredImage
            configurationChevronImageView.tintColor = theme.textColor
        }
        
        acknowledgmentsTableViewCell.selectionStyle = .none
        acknowledgmentsTableViewCell.backgroundColor = theme.backgroundColor
        acknowledgmentsLabel.textColor = theme.textColor
        
        if let image = acknowledgmentsChevronImageView.image {
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            acknowledgmentsChevronImageView.image = coloredImage
            acknowledgmentsChevronImageView.tintColor = theme.textColor
        }
    }
    
}

extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: SettingViewController.showThemeSegueIdentifier, sender: nil)
        case 1:
            performSegue(withIdentifier: SettingViewController.showConfigurationSegueIdentifier, sender: nil)
        case 2:
            performSegue(withIdentifier: SettingViewController.showAcknowledgementSegueIdentifier, sender: nil)
        default:
            return
            // do nothing
        }
    }
    
}


