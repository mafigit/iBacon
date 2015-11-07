//
//  EditBeaconTableViewController.swift
//  ibacon
//
//  Created by Maximilian Fischer on 07/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import UIKit
import CoreData


class EditBeaconTableViewController: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var beacon_uuid = ""


    @IBOutlet var NameField: UITextField!
    @IBOutlet var ServerUrlField: UITextField!
    @IBOutlet var EnterPostParamsField: UITextField!
    @IBOutlet var ExitPostParamsField: UITextField!
    @IBAction func DoneButton(sender: AnyObject) {
   
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Beacon",
            inManagedObjectContext:managedContext)
        
        let beacon = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        beacon.setValue(self.beacon_uuid, forKey: "uuid")
        beacon.setValue(NameField.text, forKey: "name")
        beacon.setValue(EnterPostParamsField.text, forKey: "postparamsenter")
        beacon.setValue(ExitPostParamsField.text, forKey: "postparamsexit")

        beacon.setValue(ServerUrlField.text, forKey: "serverurl")
        
        
        do {
            try managedContext.save()
            navigationController?.popToRootViewControllerAnimated(true)

            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NameField.placeholder = "MyBeacon"
        ServerUrlField.placeholder = "http://api.text.com:8080"
        EnterPostParamsField.placeholder = "id=123&region=enter"
        ExitPostParamsField.placeholder = "id=123&region=exit"
        
        let uuid = self.beacon_uuid
        
        let existing_beacon = appDelegate.getSavedBeaconByUuid(uuid).last;
        if (existing_beacon != nil) {
            NameField.text = String(existing_beacon!.valueForKey("name")!)
            EnterPostParamsField.text = String(existing_beacon!.valueForKey("postparamsenter")!)
            ExitPostParamsField.text = String(existing_beacon!.valueForKey("postparamsexit")!)
            ServerUrlField.text = String(existing_beacon!.valueForKey("serverurl")!)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
