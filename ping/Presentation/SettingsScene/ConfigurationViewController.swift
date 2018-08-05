//
//  ConfigurationViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 05.08.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class ConfigurationViewController: UITableViewController {
    
    var pingConfiguration: PingConfiguration {
        get {
            return PingConfiguration()
        }
        set(value) {
            
        }
    }
    
    var payloadSizes: [UInt8] = Array(1...255)
    
    var selectedPickerTableViewCell: Int = -1
    @IBOutlet var tableViewCells: [UITableViewCell]!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var valueTextFields: [UITextField]!
    @IBOutlet var pickerViews: [UIPickerView]!

    
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Configuration"
        
        for pickerView in pickerViews {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
        
        let pingConfiguration = self.pingConfiguration
        valueTextFields[0].text = String(format:"%u bytes", pingConfiguration.payload)
        valueTextFields[1].text = String(format:"%u", pingConfiguration.ttl)
        valueTextFields[2].text = String(format:"%.1f seconds", pingConfiguration.frequency)
        valueTextFields[3].text = String(format:"%.1f seconds", pingConfiguration.timeout)
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
        
        for cell in tableViewCells {
            cell.backgroundColor = theme.backgroundColor
            cell.selectionStyle = .none
        }
        for label in titleLabels {
            label.textColor = theme.textColor
        }
        for textfield in valueTextFields {
            textfield.textColor = theme.textColor
            textfield.tintColor =  theme.tintColor
            textfield.isUserInteractionEnabled = false
        }
        
        for pickerView in pickerViews {
            pickerView.backgroundColor = theme.backgroundColor
            pickerView.tintColor = theme.tintColor
        }
    }
    
}

// MARK UITableViewDelegate
extension ConfigurationViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            
            
            if indexPath.row == 0 {
                valueTextFields[0].textColor = Injection.theme.tintColor
                if let row = payloadSizes.index(where: { $0 == pingConfiguration.payload }) {
                    pickerViews[0].selectRow(row, inComponent: 0, animated: false)
                }
            }
            
            selectedPickerTableViewCell = indexPath.row + 1
            UIView.animate(withDuration: 0.3, animations: {
                // needed for aniamtion to work
                tableView.beginUpdates()
                tableView.endUpdates()
                })
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return super.tableView(tableView, heightForRowAt: indexPath)
        } else {
            if indexPath.row == selectedPickerTableViewCell {
                return 128.0
            } else {
                return 0
            }
        }
    }
 
}

// MARK: UIPickerViewDataSource
extension ConfigurationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return payloadSizes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        switch pickerView.tag {
        case 0:
            string = String(format:"%u bytes", payloadSizes[row])
        default:
            string = ""
        }
        return NSAttributedString(string: string, attributes: [.foregroundColor: Injection.theme.textColor])
    }
    
}

// MARK: UIPickerViewDelegate
extension ConfigurationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            valueTextFields[0].text = String(format:"%u bytes", payloadSizes[row])
        default:
            return
        }
    }
}
