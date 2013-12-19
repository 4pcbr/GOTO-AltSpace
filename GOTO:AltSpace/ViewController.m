//
//  ViewController.m
//  GOTO:AltSpace
//
//  Created by 4pcbr on 12/18/13.
//  Copyright (c) 2013 AltSpace. All rights reserved.
//

#import "ViewController.h"
#include <stdlib.h>

@interface ViewController ()
@end

@implementation ViewController

@synthesize distanceLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    directionData = [[DirectionData alloc] init];
    
    compassArrowImage = [self createCenteredImageWithName:@"as-app-00a.png"];
    compassDigitsImage = [self createCenteredImageWithName:@"as-app-04.png"];
    
    altSpaceArrowImage = [self createCenteredImageWithName:@"as-app-01.png"];
    altSpaceDigitsImage = [self createCenteredImageWithName:@"as-app-11.png"];
    
    distanceView = [self createCenteredImageWithName:@"as-app-00.png"];
    
    randomRotatedImages = [[NSMutableArray alloc] init];
    
    NSArray *randomRotatedImageNames = [[NSArray alloc] initWithObjects:@"as-app-02", @"as-app-03", @"as-app-05", @"as-app-06", @"as-app-07", @"as-app-08", @"as-app-09", @"as-app-10", @"as-app-12", nil];
    
    for (NSString* imageName in randomRotatedImageNames) {
        [randomRotatedImages addObject:[self createCenteredImageWithName:imageName]];
    }
    
    isTargetLocked = false;
    isCompassLocked = false;
    
    [self startRandomRotation];
    
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    
    [directionData setDelegateObj:self];
    [directionData initLocationManager];
    
    distanceLabel.font = [UIFont fontWithName:@"circe" size:16];
    
    [self.view bringSubviewToFront:distanceLabel];
}

- (UIImageView*)createCenteredImageWithName:(NSString*)imageName {
    UIImageView *referencedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [referencedImageView setCenter:[self.view convertPoint:self.view.center fromView:self.view.superview]];
    [self.view addSubview:referencedImageView];
    
    return referencedImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setCompassAngle:(double)angle {
    if (isCompassLocked) return;
    isCompassLocked = true;
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         compassArrowImage.transform = CGAffineTransformMakeRotation(angle);
                         compassDigitsImage.transform = CGAffineTransformMakeRotation(angle);
                     }
                     completion:^(BOOL finished){
                         isCompassLocked = false;
                     }];
}

- (void) setTargetAngle:(double)angle {
    if (isTargetLocked) return;
    isTargetLocked = true;
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         altSpaceArrowImage.transform = CGAffineTransformMakeRotation(angle);
                         altSpaceDigitsImage.transform = CGAffineTransformMakeRotation(angle);
                     }
                     completion:^(BOOL finished){
                         isTargetLocked = false;
                     }];
}

- (void) setDistanceToTarget:(double)distance {
    NSLog(@"distance: %f", distance);
    NSString *units;
    
    if (distance < 1000) {
        units = @"m";
    } else {
        distance /= 1000.0;
        units = @"km";
    }
    NSString *numberString = [[formatter stringFromNumber:[NSNumber numberWithDouble:distance]] stringByAppendingString:units];
    NSLog(numberString);
    distanceLabel.text = numberString;
}

- (void) startRandomRotation {
    for (UIImageView* imageView in randomRotatedImages) {
        [self initRandomRotationOfImage:imageView];
    }
}

- (void) initRandomRotationOfImage:(UIImageView*) imageView {
    int duration = arc4random() % 60;
    int delay = arc4random() % 5;
    int angle = arc4random() % 5 * 360;
    
    ViewController* this = self;
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         imageView.transform = CGAffineTransformMakeRotation(angle);
                     }
                     completion:^(BOOL finished) {
                         [this initRandomRotationOfImage:imageView];
                     }];
}

@end
