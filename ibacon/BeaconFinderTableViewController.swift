//
//  BeaconFinderTableViewController.swift
//  ibacon
//
//  Created by Maximilian Fischer on 05/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import UIKit
import CoreData

class BeaconFinderTableViewController: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        self.tableView.addSubview(refreshControl!)

        
       
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender:AnyObject){
        self.tableView.reloadData()
        self.refreshControl!.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var visible_beacons = [VisibleBeacon]()
        for beacon in appDelegate.Beacons {
            if (!beacon.beacon.proximityUUID.UUIDString.isEmpty) {
                visible_beacons.append(beacon)
            }
        }
        return visible_beacons.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("beacon_cell", forIndexPath: indexPath)
        // Configure the cell...
        var visible_beacons = [VisibleBeacon]()
        for beacon in appDelegate.Beacons {
            if (!beacon.beacon.proximityUUID.UUIDString.isEmpty) {
                visible_beacons.append(beacon)
            }
        }
        let current_beacon = visible_beacons[indexPath.row]
        let uuid = current_beacon.beacon.proximityUUID.UUIDString
        var label_text = String(uuid)
        
        let last_save_beacon_with_uuid = appDelegate.getSavedBeaconByUuid(uuid)
        if (last_save_beacon_with_uuid.last != nil) {
            label_text = String(last_save_beacon_with_uuid.last!.valueForKey("name")!)
        }

        cell.textLabel!.text = label_text
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
    
    override func prepareForSegue(segue:(UIStoryboardSegue!), sender:AnyObject!) {
        if (segue.destinationViewController is EditBeaconTableViewController) {
            let editBeaconViewController = ((segue.destinationViewController) as! EditBeaconTableViewController)
            let indexPath = self.tableView.indexPathForSelectedRow!
            var visible_beacons = [VisibleBeacon]()
            for beacon in appDelegate.Beacons {
                if (!beacon.beacon.proximityUUID.UUIDString.isEmpty) {
                    visible_beacons.append(beacon)
                }
            }
            if visible_beacons.count > 0 {
              let selected_beacon = visible_beacons[indexPath.row]
              editBeaconViewController.beacon_uuid = selected_beacon.beacon.proximityUUID.UUIDString
            }
        }
    }
  

}
