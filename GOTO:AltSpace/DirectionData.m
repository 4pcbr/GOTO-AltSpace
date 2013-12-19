//
//  DirectionData.m
//  GOTO:AltSpace
//
//  Created by 4pcbr on 12/18/13.
//  Copyright (c) 2013 AltSpace. All rights reserved.
//

#import "DirectionData.h"

@implementation DirectionData

@synthesize locationManager;
@synthesize delegateObj;

double const AltSpaceLat = 37.608754;
double const AltSpaceLon = 55.741058;

- (void) initLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.headingFilter = 1;
    locationManager.delegate = self;
    
    deferringUpdates = NO;
    
    [locationManager startUpdatingHeading];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

    double newRad = -newHeading.trueHeading * M_PI / 180.0;
    
    if (!curHeading) {
        [locationManager startUpdatingLocation];
    }
    
    curHeading = [[NSNumber alloc] initWithDouble:newHeading.trueHeading];
    
    if (delegateObj) {
        [delegateObj setCompassAngle:newRad];
        [self updateTarget];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *newLocation = [locations firstObject];
    
    double deltaLat = newLocation.coordinate.latitude - AltSpaceLat;
    double deltaLon = newLocation.coordinate.longitude - AltSpaceLon;
    double distance = sqrt(pow(deltaLat, 2.0) + pow(deltaLon, 2.0));
    
    curDeltaLat = [[NSNumber alloc] initWithDouble:deltaLat];
    curDeltaLon = [[NSNumber alloc] initWithDouble:deltaLon];
    
    [self updateTarget];
    
    if (delegateObj) {
        [delegateObj setDistanceToTarget:distance];
    }
    
    if (!deferringUpdates) {
        
        [locationManager allowDeferredLocationUpdatesUntilTraveled:5.0 timeout:30.0];
        deferringUpdates = YES;
    }
    
    
    NSLog(@"%f", [curHeading doubleValue]);
}

- (void) updateTarget {
    if (curHeading && curDeltaLon && curDeltaLat) {
        
        double deltaLat = [curDeltaLat doubleValue];
        double deltaLon = [curDeltaLon doubleValue];
        
        double angle;
        
        if (deltaLat == 0) {
            if (deltaLon > 0) {
                angle = 90;
            } else {
                angle = -90;
            }
        } else {
            angle = atan(deltaLon / deltaLat);
        }
        
        if (delegateObj) {
            angle = -1 * [curHeading doubleValue] * M_PI / 180.0 - angle;
            [delegateObj setTargetAngle:angle];
        }
    }
}

@end