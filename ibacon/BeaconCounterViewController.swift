//
//  BeaconCounterViewController.swift
//  ibacon
//
//  Created by Maximilian Fischer on 05/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import UIKit

class BeaconCounterViewController: UIViewController {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var beaconFinderTableView: BeaconFinderTableViewController!
    var ViewCounter = 0

    
    @IBOutlet weak var BeaconCounter: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let theViewController = self
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.beaconCounterView = theViewController
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateBeaconCounter() {
        var visible_beacons = [VisibleBeacon]()
        for beacon in appDelegate.Beacons {
            if (!beacon.beacon.proximityUUID.UUIDString.isEmpty) {
              visible_beacons.append(beacon)
            }
        }
        if ViewCounter != visible_beacons.count {
            BeaconCounter.text = String(visible_beacons.count)

        }
        ViewCounter = visible_beacons.count
      
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
