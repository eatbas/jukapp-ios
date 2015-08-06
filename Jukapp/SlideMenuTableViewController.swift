//
//  SlideMenuTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-08-05.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class SlideMenuTableViewController: UITableViewController {
    
    let menuItems = ["Search", "Favorites"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuItems[indexPath.row], forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = menuItems[indexPath.row]

        return cell
    }
}
