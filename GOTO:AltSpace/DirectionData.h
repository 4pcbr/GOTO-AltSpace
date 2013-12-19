//
//  DirectionData.h
//  GOTO:AltSpace
//
//  Created by 4pcbr on 12/18/13.
//  Copyright (c) 2013 AltSpace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface DirectionData : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (nonatomic,retain) CLLocationManager *locationManager;

FOUNDATION_EXPORT double const AltSpaceLat;
FOUNDATION_EXPORT double const AltSpaceLon;

- (void) initLocationManager;

@end
