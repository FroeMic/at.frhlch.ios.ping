//
//  AcknowledgmentsViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class AcknowledgmentsViewController: UIViewController {
    
    static let showAcknowledgementDetailSegueIdentifier = "showAcknowledgementDetail"
    static let licenseTableViewCellReuseIdentifier = "licenseTableViewCell"
    
    var licenses: [License] = []

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Acknowledgments"
        
        licenses =  Injection.licenseRepository.licenses
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        applyTheme()
        
        // Show the Navigation Bar
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let licenseDetailVC = segue.destination as? LicenseDetailViewController else {
            return
        }
        guard let license = sender as? License else {
            return
        }
        
        licenseDetailVC.license = license
    }
    
    override func viewWillLayoutSubviews() {
        let desiredHeigth = textView.intrinsicContentSize.height
        textViewHeightConstraint.constant = desiredHeigth
        
        super.viewWillLayoutSubviews()
    }
    
    func applyTheme() {
        let theme = Injection.theme
        
        navigationController?.navigationBar.backgroundColor = theme.backgroundColor
        navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        navigationController?.navigationBar.tintColor = theme.textColor
        navigationController?.navigationBar.barTintColor = theme.backgroundColor

        view.backgroundColor = theme.backgroundColor

        tableView.backgroundColor = theme.backgroundColor
        titleLabel.textColor = theme.textColor
        textView.textColor = theme.textColor
    }
    
    
    
}

// MARK: UITableViewDelegate
extension AcknowledgmentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let license = licenses[indexPath.row]
        performSegue(withIdentifier: AcknowledgmentsViewController.showAcknowledgementDetailSegueIdentifier, sender: license)
    }
    
}

// MARK: UITableViewDataSource
extension AcknowledgmentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AcknowledgmentsViewController.licenseTableViewCellReuseIdentifier, for: indexPath)
        
        if let licenseCell = cell as? LicenseTableViewCell {
            licenseCell.license = licenses[indexPath.row]
        }
        
        return cell
    }

}
