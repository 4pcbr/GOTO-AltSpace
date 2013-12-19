//
//  CompassDelegate.h
//  GOTO:AltSpace
//
//  Created by 4pcbr on 12/19/13.
//  Copyright (c) 2013 AltSpace. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CompassDelegate <NSObject>
- (void) setCompassAngle:(double)angle;
- (void) setTargetAngle:(double)angle;
- (void) setDistanceToTarget:(double)distance;
@end
