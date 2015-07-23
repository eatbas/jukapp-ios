//
//  RoomsTableViewController.swift
//  Jukapp
//
//  Created by Berk Caputcu on 2015-07-22.
//  Copyright (c) 2015 Berk Caputcu. All rights reserved.
//

import UIKit

class RoomsTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rooms : [Room]!
    let api = JukappAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        rooms = [Room]()
        api.loadRooms(didLoadRooms)
    }
    
    func didLoadRooms(rooms: [Room]) {
        self.rooms = rooms
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("roomCell", forIndexPath: indexPath) as! UITableViewCell

        let room : Room
        
        room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var roomToJoin = rooms[indexPath.row]
//        api.joinRoom(roomToJoin.id)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        let path = self.tableView.indexPathForSelectedRow()!
  //      segue.destinationViewController.detail = self.detailForIndexPath(path)
    }

}
