//
//  InterfaceController.h
//  iSay WatchKit Extension
//
//  Created by Jorge Jordán on 04/04/15.
//  Copyright (c) 2015 Jorge Jordán. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    kGreenButton = 0,
    kRedButton,
    kYellowButton,
    kBlueButton
} ButtonTapped;

@interface InterfaceController : WKInterfaceController

@property (nonatomic, retain) IBOutlet WKInterfaceButton *greenButton;
@property (nonatomic, retain) IBOutlet WKInterfaceButton *redButton;
@property (nonatomic, retain) IBOutlet WKInterfaceButton *yellowButton;
@property (nonatomic, retain) IBOutlet WKInterfaceButton *blueButton;

@property (nonatomic, retain) IBOutlet WKInterfaceLabel *scoreLabel;
@property (nonatomic, retain) IBOutlet WKInterfaceLabel *bestScoreLabel;

@property (nonatomic, retain) IBOutlet WKInterfaceButton *playButton;

-(IBAction) greenButtonTouched:(id)sender;
-(IBAction) redButtonTouched:(id)sender;
-(IBAction) yellowButtonTouched:(id)sender;
-(IBAction) blueButtonTouched:(id)sender;

@end
