//
//  Beacon.swift
//  ibacon
//
//  Created by Maximilian Fischer on 05/11/15.
//  Copyright © 2015 Maximilian Fischer. All rights reserved.
//

import Foundation
import CoreLocation


class VisibleBeacon {
    var beaconRegion = CLBeaconRegion()
    var beacon = CLBeacon()
    init(beaconRegion: CLBeaconRegion, beacon: CLBeacon) {
        self.beaconRegion = beaconRegion;
        self.beacon = beacon;
    }
}
