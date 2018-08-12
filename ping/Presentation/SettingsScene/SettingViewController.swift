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
    
    @IBOutlet var getPremiumTableViewCell: UITableViewCell!
    @IBOutlet var getPremiumLabel: UILabel!
    @IBOutlet var getPremiumImageView: UIImageView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        getPremiumImageView.alpha = 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
        tableView.reloadData()
        
        if IAPHandler.shared.doesOwnProduct(id: IAPHandler.shared.PING_PREMIUM_PRODUCT_ID) {
            DispatchQueue.main.async {
                self.getPremiumImageView.alpha = 1.0
                self.getPremiumTableViewCell.alpha = 0.5
            }
        }
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else { return }
            
            if type == .purchased || type == .restored {
                DispatchQueue.main.async {
                    strongSelf.getPremiumImageView.alpha = 1.0
                    strongSelf.getPremiumTableViewCell.alpha = 0.5
                }
            }
            
        }
        
    }
    
    func applyTheme() {
        let theme = Injection.themeRepository.selectedTheme
        
        UIApplication.shared.statusBarStyle = theme.statusBarStyle
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        
        view.backgroundColor = theme.backgroundColor
        
        themeTableViewCell.selectionStyle = .none
        themeTableViewCell.backgroundColor = theme.backgroundColor
        themeLabel.textColor = theme.textColor
        
        selectedThemeLabel.text = theme.name
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
        
        getPremiumTableViewCell.selectionStyle = .none
        getPremiumTableViewCell.backgroundColor = theme.backgroundColor
        getPremiumLabel.textColor = theme.textColor
        
        if let image = getPremiumImageView.image {
            let coloredImage = image.withRenderingMode(.alwaysTemplate)
            getPremiumImageView.image = coloredImage
            getPremiumImageView.tintColor = theme.textColor
        }
    }
    
}

extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let selectedTheme = Injection.themeRepository.selectedTheme
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor =  selectedTheme.textColor.withAlphaComponent(0.65)
            headerView.tintColor = selectedTheme.backgroundColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
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
        } else {
            if IAPHandler.shared.doesOwnProduct(id: IAPHandler.shared.PING_PREMIUM_PRODUCT_ID) {
                let alertView = UIAlertController(title: "", message: "You have already bought Ping Premium.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                present(alertView, animated: true, completion: nil)
            } else {
                IAPHandler.shared.purchaseMyProduct(index: 0)
            }
        }

    }
    
}


