//
//  ViewController.swift
//  ping
//
//  Created by Michael Fröhlich on 11.06.18.
//  Copyright © 2018 Michael Fröhlich. All rights reserved.
//

import UIKit

class PingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension PingViewController: UITableViewDelegate {
    
}

extension PingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
