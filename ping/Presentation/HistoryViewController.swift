//
//  HistoryViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 12.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private static let hostCellReuseIdentifier = "hostTableViewCell"
    
    @IBOutlet var historyTableView: UITableView!
    
    var historyViewDelegate: HostHistoryViewDelegate?
    
    private var hostHistory: [Host] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostHistory = Injection.hostRepository.get()
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        Injection.hostRepository.subscribe(self)
        
        view.backgroundColor = .black
        historyTableView.backgroundColor = .black
        historyTableView.backgroundView?.backgroundColor = .black
        historyTableView.separatorStyle = .none
    }
    
    func reloadHostHistory() {
        hostHistory = Injection.hostRepository.get()
        historyTableView?.reloadData()
    }
}

// MARK: UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let host = hostHistory[indexPath.row]
        historyViewDelegate?.didSelectHost(host: host)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let host = hostHistory.remove(at: indexPath.row)
            
            // use async to avoid showing white background.
            DispatchQueue.main.async {
                self.historyTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            Injection.hostRepository.remove(host: host)
            
        }
    }
    
}

// MARK: UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hostHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewController.hostCellReuseIdentifier, for: indexPath)
        
        if let hostCell = cell as? HostTableViewCell {
            hostCell.host = hostHistory[indexPath.row]
        }
        
        return cell
    }
}

extension HistoryViewController: HostHistoryObserver {
    
    func update(_ all: [Host], new: Host) {
        hostHistory.insert(new, at: 0)
        
        // Better than reload the whole tableview
        historyTableView.beginUpdates()
        historyTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        historyTableView.endUpdates()
    }
}
