//
//  ThemeSelectionViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class ThemeSelectionViewController: UIViewController {

    let themes: [ThemeProvider] = [
        LightTheme(),
        DarkTheme()
    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Themes"

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
    }
    
}


// MARK: UITableViewDelegate
extension ThemeSelectionViewController: UITableViewDelegate {
    
    
    
}

// MARK: UITableViewDataSource
extension ThemeSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "" ,
            for: indexPath)
        
        if let themeCell = cell as? ThemeSelectionViewCell {
            let theme = themes[indexPath.row]
            themeCell.theme = theme
            themeCell.isSelectedTheme
        }
        
        return cell
    }
}
