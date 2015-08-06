//
//  FavoritesTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-20.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favoritesTable: UITableView!
    @IBOutlet weak var openBarButton: UIBarButtonItem!

    var favoriteVideos : [Video]!
    let api = JukappAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.favoritesTable.dataSource = self
        self.favoritesTable.delegate = self
        
        openBarButton.target = revealViewController()
        openBarButton.action = Selector("revealToggle:")
        
        favoriteVideos = [Video]()
        api.loadFavorites(didLoadVideos)
    }
    
    func didLoadVideos(videos: [Video]) {
        self.favoriteVideos = videos
        self.favoritesTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! UITableViewCell
        
        let video : Video
        
        video = favoriteVideos[indexPath.row]
        
        cell.textLabel?.text = video.title
        cell.detailTextLabel?.text = video.youtube_id
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var videoToQueue = favoriteVideos[indexPath.row]
        api.addToQueue(videoToQueue.youtube_id, withTitle: videoToQueue.title)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
