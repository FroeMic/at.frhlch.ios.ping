//
//  ThemeSelectionViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class ThemeSelectionViewController: UIViewController {
    
    private static let selectThemeTableViewCellReuseIdentifier = "SelectThemeTableViewCell"

    var selectedTheme: AppTheme = Injection.themeRepository.selectedTheme
    var themes: [AppTheme] = Injection.themeRepository.get()

    var freeThemes: [AppTheme] {
        return themes.filter({!$0.isPremiumTheme})
    }
    var premiumThemes: [AppTheme] {
        return themes.filter({$0.isPremiumTheme})
    }
    
    @IBOutlet var tableView: UITableView!
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Themes"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedTheme = Injection.themeRepository.selectedTheme
        themes = Injection.themeRepository.get()
        tableView.reloadData()
        
        applyTheme()
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func applyTheme() {
        let theme = Injection.themeRepository.selectedTheme
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor
        
        view.backgroundColor = theme.backgroundColor
        tableView.backgroundColor =  theme.backgroundColor
    }
    
    func selectTheme(theme: AppTheme) {
        Injection.themeRepository.select(theme: theme)
        selectedTheme = theme
        applyTheme()
    }
}


// MARK: UITableViewDelegate
extension ThemeSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectTheme(theme: freeThemes[indexPath.row])
        } else {
            selectTheme(theme: premiumThemes[indexPath.row])
        }
        
        tableView.reloadData()
    }
    
    
    
}

// MARK: UITableViewDataSource
extension ThemeSelectionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Free"
        } else {
            return "Premium"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor =  selectedTheme.textColor.withAlphaComponent(0.65)
            headerView.tintColor = selectedTheme.backgroundColor
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return freeThemes.count
        } else {
            return premiumThemes.count
        }
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var theme: AppTheme
        if indexPath.section == 0 {
            theme = freeThemes[indexPath.row]
        } else {
            theme = premiumThemes[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ThemeSelectionViewController.selectThemeTableViewCellReuseIdentifier ,
            for: indexPath)

        if let themeSelectionTableViewCell = cell as? SelectThemeTableViewCell {
            
            themeSelectionTableViewCell.theme = theme
            themeSelectionTableViewCell.isSelectedTheme = theme.name == selectedTheme.name
            
        }
        
        return cell
    }
}
