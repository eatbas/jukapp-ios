//
//  RoomsTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-22.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rooms : [Room]!
    let api = JukappAPI()
    @IBOutlet weak var roomsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomsTable.dataSource = self
        roomsTable.delegate = self

        rooms = [Room]()
        api.loadRooms { (rooms: [Room]) in
            self.rooms = rooms
            self.roomsTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("roomCell", forIndexPath: indexPath) as! UITableViewCell
        
        let room : Room
        
        room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let roomToJoin = rooms[indexPath.row]
        api.joinRoom(roomToJoin.id, completion: { (joinSuccess: Bool) in
            if joinSuccess {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                println("Room does not exist")
            }
        })
    }
}
