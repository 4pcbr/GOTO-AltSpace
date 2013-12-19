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

double const AltSpaceLat = 37.608754;
double const AltSpaceLon = 55.741058;

- (void) initLocationManager {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.delegate = self;
    [locationManager startUpdatingHeading];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad = -newHeading.trueHeading * M_PI / 180.0f;
    NSLog(
          @"%f (%f) => %f (%f)",
          manager.heading.trueHeading,
          oldRad,
          newHeading.trueHeading,
          newRad
    );
}

@end