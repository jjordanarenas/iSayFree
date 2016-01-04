//
//  InterfaceController.m
//  iSay WatchKit Extension
//
//  Created by Jorge Jordán on 04/04/15.
//  Copyright (c) 2015 Jorge Jordán. All rights reserved.
//

#import "InterfaceController.h"

#define k_SLOW_TAP_SPEED 0.8f
#define k_MEDIUM_TAP_SPEED 0.4f
#define k_FAST_TAP_SPEED 0.2f
#define k_ULTRA_FAST_TAP_SPEED 0.1f

#define k_DELAY_IN_SECONDS 1.0f

#define k_USER_TURN_DELAY 5.0f

#define k_NUM_OF_BUTTONS 4

#define k_MAX_LEVEL 100

#define k_LEVEL_EASY 4
#define k_LEVEL_MEDIUM 10
#define k_LEVEL_HARD 20
#define k_LEVEL_ULTRA_HARD 100

#define k_USER_DEF_BEST_LEVEL @"best_level"

@interface InterfaceController()

@end


@implementation InterfaceController {
    BOOL isMyTurn;
    
    int numOfTaps;
    int level;
    
    float tapsSpeed;
    
    NSTimer *timer;
    
    int myTurnTaps[k_MAX_LEVEL];
    int playersTurnTaps[k_MAX_LEVEL];
    
    float currentDelay;
    
    BOOL isPlayerGameOver;
}

@synthesize greenButton, blueButton, yellowButton, redButton, playButton;
@synthesize scoreLabel, bestScoreLabel;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    isMyTurn = TRUE;
    
    level = -1;
    
    tapsSpeed = k_SLOW_TAP_SPEED;
    
    isPlayerGameOver = FALSE;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    bestScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)[userDefaults integerForKey:k_USER_DEF_BEST_LEVEL]];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction) playButtonTouched:(id)sender {
    [self performSelector:@selector(myTurn) withObject:NULL afterDelay:k_DELAY_IN_SECONDS];
    
    [playButton setEnabled:FALSE];
}

- (void) myTurn {
    
    [playButton setTitle:@"My Turn"];
    
    [self initializeTurn];
    
    [self replayPreviousLevels];
    
    [self performSelector:@selector(showCurrentTurnTap) withObject:NULL afterDelay:(2 * level + 1) * currentDelay];
    
    [self performSelector:@selector(playersTurn) withObject:NULL afterDelay:((2 * level + 2.5) * currentDelay)];
}

- (void) initializeTurn {
    numOfTaps = 0;
    level++;
    
    if (level <= k_LEVEL_EASY) {
        currentDelay = k_SLOW_TAP_SPEED;
    } else if (level <= k_LEVEL_MEDIUM) {
        currentDelay = k_MEDIUM_TAP_SPEED;
    } else if (level <= k_LEVEL_HARD) {
        currentDelay = k_FAST_TAP_SPEED;
    } else if (level <= k_LEVEL_ULTRA_HARD) {
        currentDelay = k_ULTRA_FAST_TAP_SPEED;
    }
    
    [scoreLabel setText:[NSString stringWithFormat:@"%d", level]];
}

- (void) showCurrentTurnTap {
    int tap = arc4random() % k_NUM_OF_BUTTONS;
    
    myTurnTaps[numOfTaps] = tap;
    
    switch (tap) {
        case kGreenButton:
            
            [greenButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            
            break;
            
        case kRedButton:
            
            [redButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        case kYellowButton:
            
            [yellowButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        case kBlueButton:
            
            [blueButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        default:
            break;
    }
    
    numOfTaps++;
}

- (void) restoreButtonStateWithIndex:(NSNumber *)index {
    int buttonIndex = [index intValue];
    
    switch (buttonIndex) {
        case kGreenButton:
            [greenButton setEnabled:TRUE];
            break;
            
        case kRedButton:
            [redButton setEnabled:TRUE];
            break;
            
        case kYellowButton:
            [yellowButton setEnabled:TRUE];
            break;
            
        case kBlueButton:
            [blueButton setEnabled:TRUE];
            break;
            
        default:
            break;
    }
}

- (void) replayPreviousLevels {
    for (int i = 0; i < level; i++) {
        [self performSelector:@selector(playTapWithIndex:) withObject:[NSNumber numberWithInt:i] afterDelay:((2 * i + 1) * currentDelay)];
        numOfTaps++;
    }
}

- (void) playTapWithIndex:(NSNumber *)index {
    int i = [index intValue];
    int tap = myTurnTaps[i];
    
    switch (tap) {
        case kGreenButton:
            
            [greenButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            
            break;
            
        case kRedButton:
            
            [redButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        case kYellowButton:
            
            [yellowButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        case kBlueButton:
            
            [blueButton setEnabled:FALSE];
            [self performSelector:@selector(restoreButtonStateWithIndex:) withObject:[NSNumber numberWithInt:tap] afterDelay:currentDelay];
            break;
            
        default:
            break;
    }
}

- (IBAction) greenButtonTouched:(id)sender {
    if (!isMyTurn) {
        playersTurnTaps[numOfTaps] = kGreenButton;
        [self checkTap];
    }
}

- (IBAction) redButtonTouched:(id)sender {
    if (!isMyTurn) {
        playersTurnTaps[numOfTaps] = kRedButton;
        [self checkTap];
    }
}

- (IBAction) yellowButtonTouched:(id)sender {
    if (!isMyTurn) {
        playersTurnTaps[numOfTaps] = kYellowButton;
        [self checkTap];
    }
}

- (IBAction) blueButtonTouched:(id)sender {
    if (!isMyTurn) {
        playersTurnTaps[numOfTaps] = kBlueButton;
        [self checkTap];
    }
}

- (void) playersTurn {
    
    [playButton setTitle:@"Your Turn"];
    
    isMyTurn = FALSE;
    
    numOfTaps = 0;
    
    [self performSelector:@selector(gameOver) withObject:NULL afterDelay:k_USER_TURN_DELAY];
}

- (void) gameOver {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    int bestLevelValue = [userDefaults integerForKey:k_USER_DEF_BEST_LEVEL];
    
    scoreLabel.text = @"0";
    
    if (bestLevelValue < level) {
        [userDefaults setInteger:level forKey:k_USER_DEF_BEST_LEVEL];
        bestScoreLabel.text = [NSString stringWithFormat:@"%d", level];
    }
    
    [playButton setTitle:@"PLAY!"];
    
    [playButton setEnabled:TRUE];
    
    isMyTurn = TRUE;
    
    level = -1;
    
    tapsSpeed = k_SLOW_TAP_SPEED;
    
    isPlayerGameOver = FALSE;
}

- (void) checkTap {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(gameOver) object:NULL];
    if (playersTurnTaps[numOfTaps] == myTurnTaps[numOfTaps]) {
        numOfTaps++;
        if (numOfTaps == level + 1) {
            isMyTurn = TRUE;
            [self myTurn];
        } else {
            [self performSelector:@selector(gameOver) withObject:NULL afterDelay:k_USER_TURN_DELAY];
        }
    } else {
        isPlayerGameOver = TRUE;
        [self gameOver];
    }
}

- (void) initializeValuesForTesting {
    level = 5;
    numOfTaps = level - 1;
    myTurnTaps[0] = 0;
    myTurnTaps[1] = 1;
    myTurnTaps[2] = 2;
    myTurnTaps[3] = 3;
}
@end




