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
            return Injection.pingConfigurationRepository.get()
        }
        set(newConfiguration) {
            Injection.pingConfigurationRepository.store(pingConfiguration: newConfiguration)
            updateContent()
        }
    }
    
    var payloadSizes: [UInt8] = Array(1...255)
    var ttlValues: [UInt8] = Array(1...255)
    var frequencyValues: [TimeInterval] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0 ]
    var timeoutValues: [TimeInterval] = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0 ]

    var selectedPickerTableViewCell: Int = -1
    @IBOutlet var tableViewCells: [UITableViewCell]!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var valueTextFields: [UITextField]!
    @IBOutlet var pickerViews: [UIPickerView]!

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Configuration"
        
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(ConfigurationViewController.resetToDefault))
        navigationItem.rightBarButtonItem = resetButton
        
        for pickerView in pickerViews {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
        
        updateContent()
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
    
    func updateContent() {
        let pingConfiguration = self.pingConfiguration
        valueTextFields[0].text = String(format:"%u bytes", pingConfiguration.payload)
        valueTextFields[1].text = String(format:"%u", pingConfiguration.ttl)
        valueTextFields[2].text = String(format:"%.1f seconds", pingConfiguration.frequency)
        valueTextFields[3].text = String(format:"%.1f seconds", pingConfiguration.timeout)
    }
    
    @objc func resetToDefault() {
        pingConfiguration = PingConfiguration()
    }
    
}

// MARK UITableViewDelegate
extension ConfigurationViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            
            for textField in valueTextFields {
                textField.textColor = Injection.theme.textColor
            }
            
            if indexPath.row == 0 {
                valueTextFields[0].textColor = Injection.theme.tintColor
                if let row = payloadSizes.index(where: { $0 == pingConfiguration.payload }) {
                    pickerViews[0].selectRow(row, inComponent: 0, animated: false)
                }
            } else if indexPath.row == 2 {
                valueTextFields[1].textColor = Injection.theme.tintColor
                if let row = ttlValues.index(where: { $0 == pingConfiguration.ttl }) {
                    pickerViews[1].selectRow(row, inComponent: 0, animated: false)
                }
            } else if indexPath.row == 4 {
                valueTextFields[2].textColor = Injection.theme.tintColor
                if let row = frequencyValues.index(where: { $0 == pingConfiguration.frequency }) {
                    pickerViews[2].selectRow(row, inComponent: 0, animated: false)
                }
            } else if indexPath.row == 6 {
                valueTextFields[3].textColor = Injection.theme.tintColor
                if let row = timeoutValues.index(where: { $0 == pingConfiguration.timeout }) {
                    pickerViews[3].selectRow(row, inComponent: 0, animated: false)
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
        case 1:
            return ttlValues.count
        case 2:
            return frequencyValues.count
        case 3:
            return timeoutValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        switch pickerView.tag {
        case 0:
            string = String(format:"%u bytes", payloadSizes[row])
        case 1:
            string = String(format:"%u", ttlValues[row])
        case 2:
           string = String(format:"%.1f seconds", frequencyValues[row])
        case 3:
            string = String(format:"%.1f seconds", timeoutValues[row])
        default:
            string = ""
        }
        return NSAttributedString(string: string, attributes: [.foregroundColor: Injection.theme.textColor])
    }
    
}

// MARK: UIPickerViewDelegate
extension ConfigurationViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let oldConfiguration = pingConfiguration
        
        switch pickerView.tag {
        case 0:
            pingConfiguration = PingConfiguration(
                timeout: oldConfiguration.timeout,
                frequency: oldConfiguration.frequency,
                ttl: oldConfiguration.ttl,
                payload: payloadSizes[row])
        case 1:
            pingConfiguration = PingConfiguration(
                timeout: oldConfiguration.timeout,
                frequency: oldConfiguration.frequency,
                ttl: ttlValues[row],
                payload: oldConfiguration.payload)
        case 2:
            pingConfiguration = PingConfiguration(
                timeout: oldConfiguration.timeout,
                frequency: frequencyValues[row],
                ttl: oldConfiguration.ttl,
                payload: oldConfiguration.payload)
        case 3:
            pingConfiguration = PingConfiguration(
                timeout: timeoutValues[row],
                frequency: oldConfiguration.frequency,
                ttl: oldConfiguration.ttl,
                payload: oldConfiguration.payload)
        default:
            return
        }
    }
}
