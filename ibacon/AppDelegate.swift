//
//  AppDelegate.swift
//  ibacon
//
//  Created by Maximilian Fischer on 04/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {


    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var Beacons: [VisibleBeacon] = [];
    var beaconCounterView: BeaconCounterViewController!


    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
            
       
            locationManager = CLLocationManager()
            if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
                locationManager!.requestAlwaysAuthorization()
            }
            locationManager!.allowsBackgroundLocationUpdates = true
            locationManager!.delegate = self
            locationManager!.pausesLocationUpdatesAutomatically = false
            
       

            for beacon in getNewBeacons() {
              let uuid = String(beacon.valueForKey("uuid")!)
              addNewBeacon(uuid, beaconIdentifier: uuid)
            }
            
            locationManager!.startUpdatingLocation()
            
            if(application.respondsToSelector("registerUserNotificationSettings:")) {
                application.registerUserNotificationSettings(
                    UIUserNotificationSettings(
                        forTypes: UIUserNotificationType.Alert,
                        categories: nil
                    )
                )
            }
         
            
            return true
    }
    
    func addNewBeacon(uuidString: String, beaconIdentifier: String) {
        if (NSUUID(UUIDString: uuidString) != nil) {
            let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
            let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
            locationManager!.startMonitoringForRegion(beaconRegion)
            locationManager!.startRangingBeaconsInRegion(beaconRegion)
            locationManager!.startUpdatingLocation()
        }
        return
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      
        NSLog("App is backgrounded")

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func sendPostRequest(url: String!, postparams: String!) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = postparams
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()

    }
    
    func addToVisibleBeacons(beacon: CLBeacon, region: CLBeaconRegion) {

        
        if (Beacons.count == 0 && !beacon.proximityUUID.UUIDString.isEmpty) {
          let new_visible_beacon = VisibleBeacon(beaconRegion: region, beacon: beacon)
            
          Beacons = [new_visible_beacon]
          return
        }
        
        let visible_beacons_identifiers = Beacons.map{$0.beaconRegion.identifier}
        if (!visible_beacons_identifiers.contains(region.identifier)) {
            let new_visible_beacon = VisibleBeacon(beaconRegion: region, beacon: beacon)
            Beacons.append(new_visible_beacon)
        } else {
            Beacons = Beacons.map{
                if ($0.beaconRegion.identifier == region.identifier) {
                    let new_visible_beacon = VisibleBeacon(beaconRegion: region, beacon: beacon)
                    return new_visible_beacon
                }
                return $0
            }
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        var message:String = ""
        var nearestBeacon = CLBeacon()
        
        if(beacons.count > 0) {
          nearestBeacon = beacons[0] as CLBeacon
        }
        addToVisibleBeacons(nearestBeacon, region: region)

        
       
        if (self.beaconCounterView != nil) {
          self.beaconCounterView!.updateBeaconCounter()
        }
        
        if(beacons.count > 0) {
            
            let nearestBeacon:CLBeacon = beacons[0] as CLBeacon

            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                    return;
            }
            lastProximity = nearestBeacon.proximity;
            
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are far away from the beacon"
            case CLProximity.Near:
                message = "You are near the beacon"
            case CLProximity.Immediate:
                message = "You are in the immediate proximity of the beacon"
                sendLocalNotificationWithMessage("Very close");
            case CLProximity.Unknown:
                return
            }
        } else {
            message = "No beacons are nearby"
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        let beacon = getSavedBeaconByUuid(region.identifier).last;
        if(beacon != nil) {
            let server_url = String(beacon!.valueForKey("serverurl")!)
            let post_params = String(beacon!.valueForKey("postparamsenter")!)
            
            sendLocalNotificationWithMessage("You entered the region")
            sendPostRequest(server_url, postparams: post_params);
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        let beacon = getSavedBeaconByUuid(region.identifier).last;
        if(beacon != nil) {
            let server_url = String(beacon!.valueForKey("serverurl")!)
            let post_params = String(beacon!.valueForKey("postparamsexit")!)
            
            sendLocalNotificationWithMessage("You exited the region")
            sendPostRequest(server_url, postparams: post_params);
        }

    }
    
    func getNewBeacons() -> [NSManagedObject]{
        let fetchRequestBeacon = NSFetchRequest(entityName: "NewBeacon")
        do {
            
            let resultsBeacons = try managedObjectContext.executeFetchRequest(fetchRequestBeacon)
            let new_beacons = resultsBeacons as! [NSManagedObject]
            return new_beacons
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return []
    }
    
    func getNewBeaconByUuid(uuid: String) -> [NSManagedObject] {
        //returns Array of all beacons with given uuid(note: there can be multible entries with that uuid)
        let beacons = self.getNewBeacons()
        var new_beacons = [NSManagedObject]()
        for beacon in beacons {
            let new_beacon_uuid = String(beacon.valueForKey("uuid")!)
            if (new_beacon_uuid == uuid) {
                new_beacons.append(beacon)
            }
        }
        return new_beacons
    }


    
    func getSavedBeacons() -> [NSManagedObject]{
      let fetchRequestBeacon = NSFetchRequest(entityName: "Beacon")
        do {
            
            let resultsBeacons = try managedObjectContext.executeFetchRequest(fetchRequestBeacon)
            let beacons = resultsBeacons as! [NSManagedObject]
            return beacons
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return []
    }

    func getSavedBeaconByUuid(uuid: String) -> [NSManagedObject] {
        let beacons = self.getSavedBeacons()
        var saved_beacons = [NSManagedObject]()
        for beacon in beacons {
            let saved_beacon_uuid = String(beacon.valueForKey("uuid")!)
            if (saved_beacon_uuid == uuid) {
                saved_beacons.append(beacon)
            }
        }
        return saved_beacons 
    }
    
    func uuidAlreadySaved(uuid: String) -> Bool {
        let last_save_beacon_with_uuid = self.getSavedBeaconByUuid(uuid).last
        if (last_save_beacon_with_uuid != nil) {
            return true
        }
        return false
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.inagile.testcore" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }


}

