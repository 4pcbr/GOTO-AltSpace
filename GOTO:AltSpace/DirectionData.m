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

double const AltSpaceLat = 55.741058;
double const AltSpaceLon = 37.608754;
double const RADIUS = 6371000;

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
    
    double deltaLatRad = deltaLat * M_PI / 180;
    double deltaLonRad = deltaLon * M_PI / 180;
    double lat1Rad = newLocation.coordinate.latitude * M_PI / 180;
    double lat2Rad = AltSpaceLat * M_PI / 180;
    
    double a = pow(sin(deltaLatRad / 2.0), 2.0) + pow(sin(deltaLon / 2.0), 2.0) * cos(lat1Rad) * cos(lat2Rad);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = RADIUS * c;
    
    curLat = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
    curLon = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
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
        
        double deltaLatRad = [curDeltaLat doubleValue] * M_PI / 180;
        double deltaLonRad = [curDeltaLon doubleValue] * M_PI / 180;
        double altSpaceLatRad = AltSpaceLat * M_PI / 180;
        double altSpaceLonRad = AltSpaceLon * M_PI / 180;
        double curLatRad = [curLat doubleValue] * M_PI / 180;
        double curLonRad = [curLon doubleValue] * M_PI / 180;
        
        double y = sin(deltaLonRad) * cos(altSpaceLatRad);
        double x = cos(curLatRad) * sin(altSpaceLatRad) - sin(curLatRad) * cos(altSpaceLatRad) * cos(deltaLonRad);
        double angle = atan2(y, x) * 180 / M_PI;
        
        if (delegateObj) {
            angle = -1 * [curHeading doubleValue] * M_PI / 180.0 - angle;
            [delegateObj setTargetAngle:angle];
        }
    }
}

@end