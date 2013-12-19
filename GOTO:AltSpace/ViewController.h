//
//  ViewController.h
//  GOTO:AltSpace
//
//  Created by 4pcbr on 12/18/13.
//  Copyright (c) 2013 AltSpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionData.h"
#import "CompassDelegate.h"

float const FRAME_WIDTH = 1350;
float const FRAME_HEIGHT = 1350;

@interface ViewController : UIViewController<CompassDelegate> {
    DirectionData* directionData;
    UIImageView *compassArrowImage;
    UIImageView *compassDigitsImage;
    UIImageView *altSpaceArrowImage;
    UIImageView *altSpaceDigitsImage;
    UIImageView *distanceView;
    UITextField *distanceLabel;
    NSMutableArray* randomRotatedImages;
    NSNumberFormatter *formatter;
    BOOL isTargetLocked;
    BOOL isCompassLocked;
}

@property (nonatomic, retain) IBOutlet UITextField *distanceLabel;

@end
