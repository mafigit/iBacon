//
//  AddUuidTableViewController.swift
//  ibacon
//
//  Created by Maximilian Fischer on 07/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

class AddUuidTableViewController: UITableViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


    @IBOutlet var NavigationTitle: UINavigationItem!
    @IBAction func DoneButton(sender: AnyObject) {
        let new_uuid = String(UuidField.text!)
        addNewNewBeacon(new_uuid)

    }
    @IBOutlet var UuidField: UITextField!
    
    @IBAction func UuidFieldChange(sender: AnyObject) {
        removeErrorOnTextfield(UuidField)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UuidField.placeholder = "01bae841-604e-4f41-ae05-a0a47b91d2c6"


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
    func addErrorToTextfield(textField: UITextField, message: String) {
        
        textField.textColor = UIColor.redColor()
        NavigationTitle.prompt = message
    }
    
    func removeErrorOnTextfield(textField: UITextField) {
        textField.textColor = UIColor.blackColor()
        NavigationTitle.prompt = nil
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func addNewNewBeacon(uuid: String) {
        if (appDelegate.getNewBeaconByUuid(uuid).count > 0)  {
            addErrorToTextfield(UuidField, message: "Beacon already added!")
            
            
        } else if (NSUUID(UUIDString: uuid) == nil) {
            addErrorToTextfield(UuidField, message: "Wrong UUID Format!")
        } else {
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("NewBeacon",
                inManagedObjectContext:managedContext)
            
            let beacon = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            beacon.setValue(uuid, forKey: "uuid")
            
            do {
                try managedContext.save()
                appDelegate.addNewBeacon(uuid, beaconIdentifier: uuid)
                navigationController?.popToRootViewControllerAnimated(true)

                //5
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
