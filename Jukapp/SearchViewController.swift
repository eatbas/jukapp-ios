//
//  SearchTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-25.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    let api = JukappAPI()
    var searchResults : [Video]!
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var openBarButton: UIBarButtonItem!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        var currentRoom = self.defaults.integerForKey("currentRoom")
        
        if(currentRoom == 0) {
            self.performSegueWithIdentifier("joinRoomSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openBarButton.target = self.revealViewController()
        openBarButton.action = Selector("revealToggle:")
        
        searchResults = [Video]()
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self

        self.searchResultsTable.tableHeaderView = searchController.searchBar
        self.searchResultsTable.dataSource = self
        self.searchResultsTable.delegate = self
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        api.searchVideos(searchBar.text, completion: { (searchResults: [Video]) in
            self.searchResults = searchResults
            self.searchResultsTable.reloadData()
        })

        searchBar.resignFirstResponder() // hide keyboard
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultVideoCell", forIndexPath: indexPath) as! UITableViewCell
        
        let video : Video
        
        video = searchResults[indexPath.row]
        
        cell.textLabel?.text = video.title
        cell.detailTextLabel?.text = video.youtube_id
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var videoToQueue = searchResults[indexPath.row]
        api.addToQueue(videoToQueue.youtube_id, withTitle: videoToQueue.title)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
