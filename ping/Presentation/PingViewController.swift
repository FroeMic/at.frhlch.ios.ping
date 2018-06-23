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
    private var pingManager: PingManager = QNNPingManager()
    private var pingResults: [PingResult] = []

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
        
        pingManager.delegate = self
        
        configureTextField()
        configureHostView()
        configureTableView()
        configureSuggestionView()
        configureStatisticsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if pingResults.count == 0 {
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
            pingResults = []
            tableView.reloadData()
            hostViewLabel.text = "pinging \(hostName) ..."
            pingIsActive = true
            pingManager.startPing(hostName: hostName, addressStyle: .auto)
            updateStopButton()
        }
    }
    
    private func resetPingManager() {
        pingManager.delegate = nil
        pingManager.stopPing()
        pingManager = QNNPingManager()
        pingManager.delegate = self
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
        if pingIsActive {
            pingManager.stopPing()
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
        statisticsSentLabel.text = String(format: "%d", pingManager.sentPackages)
        statisticsReceivedLabel.text = String(format: "%d", pingManager.receivedPackages)
        statisticsLostLabel.text = String(format: "%d", pingManager.lostPackages)
        statisticsLossLabel.text = String(format: "%.2f", pingManager.packagesLoss)
        
        statisticsMinRTTLabel.text = String(format: "%.2f ms", pingManager.minRTT)
        statisticsMaxRTTLabel.text = String(format: "%.2f ms", pingManager.maxRTT)
        statisticsAvgRTTLabel.text = String(format: "%.2f ms", pingManager.avgRTT)
        statisticsStdevRTTLabel.text = String(format: "%.2f ms", pingManager.stdevRTT)
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

// MARK: PingDelegate
extension PingViewController: PingDelegate {
    func didStartWithAddress(host: Host) {
        Injection.hostRepository.store(host: host)
        updateStopButton()
    }
    
    func didFailWithAddress(host: Host, error: String) {
        Injection.hostRepository.store(host: host)
        
        let pingResponse = PingResult(host: host.name,
                   sizeInBytes: 0,
                   sequence: 0,
                   ttl: 0,
                   timeInMs: 0.0,
                   error: error)
        
        pingResults.insert(pingResponse, at: 0)
        tableView.reloadData()
        updateStatisticView()
    }
    
    func didReceivePingResponse(_ pingResponse: PingResult) {
        guard pingIsActive else {
            return
        }
        
        pingResults.insert(pingResponse, at: 0)
        tableView.reloadData()
        updateStatisticView()
        
        if pingResponse.host == "Ping Terminated" && pingResponse.ttl == 0 {
            pingIsActive = false
            updateStopButton()
        }
    }
    
}

// MARK: UITableViewDelegate
extension PingViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource
extension PingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pingResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PingViewController.pingCellReuseIdentifier, for: indexPath)
        
        if let pingCell = cell as? PingTableViewCell {
            pingCell.pingResponse = pingResults[indexPath.row]
        }
        
        return cell
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
