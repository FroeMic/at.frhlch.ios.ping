//
//  ViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 11.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class PingViewController: UIViewController {
    
    private static let pingCellReuseIdentifier = "pingTableViewCell"
    private static let historyViewSegueIdentifer = "historyViewSegue"
    
    private var hostHistoryVC: HistoryViewController?
    private var pingManager: PingController?

    private var pingIsActive = false
    private var historyViewIsVisible = false
    private var cancelButtonIsVisible = false

    @IBOutlet var hostTextField: AnimatedTextField!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var hostViewContainer: UIView!
    @IBOutlet var hostViewLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var suggestionView: UIView!
    @IBOutlet var zeroHeightConstraint: NSLayoutConstraint!
    @IBOutlet var zeroWidthButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet var statisticsSentLabel: UILabel!
    @IBOutlet var statisticsReceivedLabel: UILabel!
    @IBOutlet var statisticsLostLabel: UILabel!
    @IBOutlet var statisticsLossLabel: UILabel!
    @IBOutlet var statisticsMinRTTLabel: UILabel!
    @IBOutlet var statisticsMaxRTTLabel: UILabel!
    @IBOutlet var statisticsAvgRTTLabel: UILabel!
    @IBOutlet var statisticsStdevRTTLabel: UILabel!

    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        configureHostView()
        configureTableView()
        configureSuggestionView()
        configureStatisticsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if pingManager == nil {
            hostTextField.becomeFirstResponder()
        }
        
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == PingViewController.historyViewSegueIdentifer,
            let destinationVC = segue.destination as? HistoryViewController {
                destinationVC.historyViewDelegate = self
                hostHistoryVC = destinationVC
        }
        
    }
    
    func configureTextField() {
        hostTextField.delegate = self
        hostTextField.backgroundColor = .black
        hostTextField.dashColor = .white
        hostTextField.textColor = .white
        hostTextField.tintColor = .green
        hostTextField.textAlignment = .right
    }
    
    func configureHostView() {
        hostViewContainer.backgroundColor = .black
        hostViewLabel.textColor = .white
        hostViewLabel.font = UIFont(name: "Menlo-Bold", size: 16.0)
        hostViewLabel.text = ""
        hostViewLabel.adjustsFontSizeToFitWidth = true
        stopButton.isHidden = true
    }
    
    func configureTableView() {
        tableView.backgroundColor = .black
        tableView.backgroundView?.backgroundColor = .black
        
        tableView.rowHeight = 40.0
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureSuggestionView() {
        cancelButton.alpha = 0.0
        suggestionView.backgroundColor = .black
        suggestionView.alpha = 0.0
    }
    
    func configureStatisticsView() {
        statisticsSentLabel.adjustsFontSizeToFitWidth = true
        statisticsReceivedLabel.adjustsFontSizeToFitWidth = true
        statisticsLostLabel.adjustsFontSizeToFitWidth = true
        statisticsLossLabel.adjustsFontSizeToFitWidth = true
        statisticsMinRTTLabel.adjustsFontSizeToFitWidth = true
        statisticsMaxRTTLabel.adjustsFontSizeToFitWidth = true
        statisticsAvgRTTLabel.adjustsFontSizeToFitWidth = true
        statisticsStdevRTTLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func startPingIfNecessary() {
        if let hostName = hostTextField.textWithoutPrefix, hostName != "" {
            // count how often the user pings
            RatingManager.didSignificantEvent()
            
            resetPingManager()
            updateStatisticView()
            tableView.reloadData()
            hostViewLabel.text = "pinging \(hostName) ..."
            updateStopButton()
            
            // TODO init PingController
            
        }
    }
    
    private func resetPingManager() {
        
        guard var pingManager = pingManager else {
            return
        }
        
        pingManager.stop()
        pingManager.delegate = nil
        self.pingManager = nil
    }
    
    
    // MARK: UI Interaction
    @IBAction func goButtonPressed(_ sender: UIButton) {
        dismissTextField()
        startPingIfNecessary()
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissTextField()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        
        guard let pingManager = pingManager else {
            return
        }
        
        if pingManager.isPinging {
            pingManager.stop()
        } else {
            startPingIfNecessary()
        }
    }
    
    private func dismissTextField() {
        view.endEditing(true)
    }
    
    private func showHistoryView() {
        if historyViewIsVisible {
            return
        }
        
        hostHistoryVC?.reloadHostHistory()
        
        historyViewIsVisible = true
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
            self.suggestionView.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            self.zeroHeightConstraint.isActive = false
            self.view.layoutIfNeeded()
            self.stopButton.alpha = 0.0
        }
    }
    
    private func hideHistoryView() {
        if !historyViewIsVisible {
            return
        }
        
        historyViewIsVisible = false
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
            self.suggestionView.alpha = 0.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4) {
            self.zeroHeightConstraint.isActive = true
            self.view.layoutIfNeeded()
            self.stopButton.alpha = 1.0
        }
    }
    
    private func showCancelButton() {
        if cancelButtonIsVisible {
            return
        }
        cancelButtonIsVisible = true
        
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveEaseIn, animations: {
            self.cancelButton.alpha = 1.0
        }, completion: nil)
    }
    
    private func hideCancelButton() {
        if !cancelButtonIsVisible {
            return
        }
        cancelButtonIsVisible = false
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.cancelButton.alpha = 0.0
        }, completion: nil)
    }
    
    private func showGoButton() {
        UIView.animate(withDuration: 0.2) {
            self.zeroWidthButtonConstraint.isActive = false
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateStopButton() {
        if hostTextField.textWithoutPrefix == "" {
            stopButton.isHidden = true
            return
        }
        
        stopButton.isHidden = false
        if pingIsActive {
            stopButton.setImage(UIImage(named: "ic_stop"), for: .normal)
        } else {
            stopButton.setImage(UIImage(named: "ic_play"), for: .normal)
        }
    }
    
    private func hideGoButton() {
        UIView.animate(withDuration: 0.2) {
            self.zeroWidthButtonConstraint.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateGoButtonText() {
        let text = hostTextField.textWithoutPrefix ?? ""
        let buttonText = text == "" ? "Cancel" : "Go"
        goButton.setTitle(buttonText, for: .normal)
    }
    
    private func updateStatisticView() {
        guard let statistic = pingManager?.statistic else {
            return
        }
        
        statisticsSentLabel.text = String(format: "%d", statistic.sentPackages)
        statisticsReceivedLabel.text = String(format: "%d", statistic.receivedPackages)
        statisticsLostLabel.text = String(format: "%d", statistic.lostPackages)
        statisticsLossLabel.text = String(format: "%.2f", statistic.packagesLoss)
        
        statisticsMinRTTLabel.text = String(format: "%.2f ms", statistic.minRTT)
        statisticsMaxRTTLabel.text = String(format: "%.2f ms", statistic.maxRTT)
        statisticsAvgRTTLabel.text = String(format: "%.2f ms", statistic.avgRTT)
        statisticsStdevRTTLabel.text = String(format: "%.2f ms", statistic.stdevRTT)
    }
    
}

// MARK: HistoryViewDelegate
extension PingViewController: HostHistoryViewDelegate {
    
    func didSelectHost(host: Host) {
        hostTextField.textWithoutPrefix = host.name
        dismissTextField()
        startPingIfNecessary()
    }
    
}


// MARK: PinginfoDelegate


// MARK: UITableViewDelegate
extension PingViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource
extension PingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pingManager = pingManager else {
            return 0
        }
        return pingManager.pingResults.filter { $0.status != .pending }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PingViewController.pingCellReuseIdentifier, for: indexPath)
        
        guard let pingManager = pingManager else {
            return cell
        }
        
        guard let pingCell = cell as? PingTableViewCell else {
            return cell
        }
        
        pingCell.pingResponse = pingManager.pingResults[indexPath.row]
        return pingCell
    }
}

// MARK: UITextFieldDelegate
extension PingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissTextField()
        startPingIfNecessary()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showHistoryView()
        showCancelButton()
        updateGoButtonText()
        showGoButton()
        hostTextField.textFieldDidEndEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideHistoryView()
        hideCancelButton()
        hideGoButton()
        hostTextField.textFieldDidEndEditing(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let success = hostTextField.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        updateGoButtonText()
        
        return success
    }
    
}
