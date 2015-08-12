//
//  SlideMenuTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-08-05.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class SlideMenuTableViewController: UITableViewController {
    
    let menuItems = ["Search", "Favorites", "Leave Room"]
    let defaults = NSUserDefaults.standardUserDefaults()
    let api = JukappAPI()

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
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = menuItems[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var destinationNavigationController : UINavigationController
        var selectedMenu = menuItems[indexPath.row]
        
        if (selectedMenu == "Favorites" && Router.AuthToken == nil) {
            destinationNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("AuthNavigationController") as! UINavigationController
        } else if (selectedMenu == "Leave Room") {
            api.leaveRoom()
            destinationNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("RoomsNavigationController") as! UINavigationController
        } else {
            destinationNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("\(selectedMenu)NavigationController") as! UINavigationController
        }
        
        self.revealViewController().pushFrontViewController(destinationNavigationController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
