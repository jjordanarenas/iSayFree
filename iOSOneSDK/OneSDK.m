//
//  ChupamobileKit.m
/*
 * Chupamobile: http://www.chupamobile.com
 *
 * Copyright (c) 2014 Chupamobile Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "OneSDK.h"
//#import "CKDefaults.h"
#import "CKPlistManager.h"
#import <CommonCrypto/CommonHMAC.h>

#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

#import "Flurry.h"

//#import "Nextpeer/Nextpeer.h"

#import "iRate.h"

#import <RevMobAds/RevMobAds.h>

#import "ALSdk.h"
#import "ALInterstitialAd.h"

void dispatch_after_delta(float delta, dispatch_block_t block){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), dispatch_get_main_queue(), block);
}

@implementation OneSDK {
    
    BOOL isChartboostEnabled;
    BOOL isAdMobEnabled;
    BOOL isRevMobEnabled;
    BOOL isAppLovinEnabled;
    
    BOOL shouldShowChartboostAdAtLocation;
    BOOL shouldShowAdMobAdAtLocation;
    BOOL shouldShowRevMobAdAtLocation;
    BOOL shouldShowAppLovinAdAtLocation;
    
    NSInteger placementCountChartboostMainMenu;
    NSInteger placementCountAdMobMainMenu;
    NSInteger placementCountAdMobGameplay;
    NSInteger placementCountChartboostGameOver;
    NSInteger placementCountAdMobGameOver;
    NSInteger placementCountRevMobMainMenu;
    NSInteger placementCountRevMobGameplay;
    NSInteger placementCountRevMobGameOver;
    NSInteger placementCountAppLovinMainMenu;
    NSInteger placementCountAppLovinGameOver;
    
    BOOL mayShowChartboostAdAtLocation;
    BOOL mayShowAdMobBannerAdAtLocation;
    BOOL mayShowRevMobAdAtLocation;
    BOOL mayShowAppLovinAdAtLocation;
    
    NSString *chartboostAdLocation;
    
    NSString *finalToken;
    
    NSString *whatStringToSend;
}

#pragma mark Singleton Methods

+ (id)sharedSDK {
    static OneSDK *sharedMyOneSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyOneSDK = [[self alloc] init];
    });
    return sharedMyOneSDK;
}

- (id)init {
    if (self = [super init]) {
        NSLog(@"Chupamobile Kit Singleton created.");
    }
    return self;
}

- (void) startChupamobileKit {
    NSLog(@"Starting Chupamobile Kit.");
    
    [CKPlistManager setupPlistValues];
    
    // setting the flag
    if ([self isChupamobileKitLogEnabled]) {
        cKLogEnabled = YES;
    } else {
        cKLogEnabled = NO;
    }
    
    if (IRATE_ENABLED) {
        // setup iRate
        [self setupiRate];
        
        if (cKLogEnabled) {
            CKLog(@"iRate is enabled. Starting iRate.");
        }
    } else {
        if (cKLogEnabled) {
            CKLog(@"iRate is NOT enabled. Not starting iRate.");
        }
    }
    
}

- (void) showAdAt:(CKAdLocation) cKAdLocation forViewController: (UIViewController*) viewController {
    
    if (AUTHOR_MODE) {
        
        if ([self areAdsRemoved]) {
            if (cKLogEnabled) {
                CKLog(@"Ads are removed. NOT showing any ads.");
            }
        } else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                              message:@"\nDear developer,\n Congratulations on putting a placement for an ad/ads here!\n Consider this popup as the ad/ads.\n\n Your work is done here."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Got it"
                                                    otherButtonTitles:nil];
            
            [message show];
        }
        
        return;
    }
    
    if ([self areAdsRemoved]) {
        
        if (cKLogEnabled) {
            CKLog(@"Ads are removed. NOT showing any ads.");
        }
        
        return;
    }
    
    switch (cKAdLocation) {
            // MAIN MENU //
        case CKAdLocationMainMenu:
            // set location specific vars
            
            ////////////////////
            //// CHARTBOOST ////
            ////////////////////
            
            // checking if ad network is enabled
            if (CHARTBOOST_ENABLED) {
                isChartboostEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"Chartboost is enabled");
                }
                
            } else {
                isChartboostEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"Chartboost is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nChartboost is not enabled. To use Chartboost enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_CHARTBOOST_INTERSTITIAL_AT_MAIN_MENU) {
                shouldShowChartboostAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show Chartboost Ad at Main Menu.");
                }
                
            } else {
                shouldShowChartboostAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show Chartboost Ad at Main Menu.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountChartboostMainMenu = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountChartboostMainMenu];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountChartboostMainMenu % ADS_FREQUENCY_CHARTBOOST_MAIN_MENU == 0) {
                mayShowChartboostAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show Chartboost Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountChartboostMainMenu, (long)ADS_FREQUENCY_CHARTBOOST_MAIN_MENU);
                }
                
            } else {
                mayShowChartboostAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show Chartboost Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountChartboostMainMenu, (long)ADS_FREQUENCY_CHARTBOOST_MAIN_MENU);
                }
                
            }
            
            // setting up chartboost location name
            chartboostAdLocation = CBLocationMainMenu;
            
            // increasing the placement count for this ad network with this location
            placementCountChartboostMainMenu++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountChartboostMainMenu forKey:kPlacementCountChartboostMainMenu];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            /////// ADMOB //////
            ////////////////////
            
            // checking if ad network is enabled
            if (ADMOB_ENABLED) {
                isAdMobEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is enabled");
                }
                
            } else {
                isAdMobEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is disabled");
                }
                
                
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nAdMob is not enabled. To use AdMob enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_ADMOB_BANNER_AT_MAIN_MENU) {
                shouldShowAdMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show AdMob Banner at Main Menu.");
                }
                
            } else {
                shouldShowAdMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show AdMob Banner at Main Menu.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountAdMobMainMenu = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountAdMobMainMenu];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountAdMobMainMenu % ADS_FREQUENCY_ADMOB_MAIN_MENU == 0) {
                mayShowAdMobBannerAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show AdMob Banner at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobMainMenu, (long)ADS_FREQUENCY_ADMOB_MAIN_MENU);
                }
                
            } else {
                mayShowAdMobBannerAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show AdMob Banner at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobMainMenu, (long)ADS_FREQUENCY_ADMOB_MAIN_MENU);
                }
                
            }
            
            
            // increasing the placement count for this ad network with this location
            placementCountAdMobMainMenu++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountAdMobMainMenu forKey:kPlacementCountAdMobMainMenu];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            ////// REVMOB //////
            ////////////////////
            
            // checking if ad network is enabled
            if (REVMOB_ENABLED) {
                isRevMobEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"RevMob is enabled");
                }
                
            } else {
                isRevMobEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"RevMob is disabled");
                }
                
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nRevMob is not enabled. To use RevMob enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_REVMOB_BANNER_AT_MAIN_MENU || SHOW_REVMOB_INTERSTITIAL_AT_MAIN_MENU || SHOW_REVMOB_POPUP_AT_MAIN_MENU) {
                shouldShowRevMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show RevMob Ad at Main Menu.");
                }
                
            } else {
                shouldShowRevMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show RevMob Ad at Main Menu.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountRevMobMainMenu = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountRevMobMainMenu];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountRevMobMainMenu % ADS_FREQUENCY_REVMOB_MAIN_MENU == 0) {
                mayShowRevMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show RevMob Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountRevMobMainMenu, (long)ADS_FREQUENCY_REVMOB_MAIN_MENU);
                }
                
            } else {
                mayShowRevMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show RevMob Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountRevMobMainMenu, (long)ADS_FREQUENCY_REVMOB_MAIN_MENU);
                }
                
            }
            
            // increasing the placement count for this ad network with this location
            placementCountRevMobMainMenu++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountRevMobMainMenu forKey:kPlacementCountRevMobMainMenu];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            ///// APPLOVIN /////
            ////////////////////
            
            // checking if ad network is enabled
            if (APPLOVIN_ENABLED) {
                isAppLovinEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"Applovin is enabled");
                }
                
            } else {
                isAppLovinEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"AppLovin is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nAppLovin is not enabled. To use AppLovin enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_APPLOVIN_INTERSTITIAL_AT_MAIN_MENU) {
                shouldShowAppLovinAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show AppLovin Ad at Main Menu.");
                }
                
            } else {
                shouldShowAppLovinAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show AppLovin Ad at Main Menu.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountAppLovinMainMenu = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountAppLovinMainMenu];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountAppLovinMainMenu % ADS_FREQUENCY_APPLOVIN_MAIN_MENU == 0) {
                mayShowAppLovinAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show AppLovin Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountAppLovinMainMenu, (long)ADS_FREQUENCY_APPLOVIN_MAIN_MENU);
                }
                
            } else {
                mayShowAppLovinAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show AppLovin Ad at Main Menu because placement count is %li and ads frequency at this location is %li.", (long)placementCountAppLovinMainMenu, (long)ADS_FREQUENCY_APPLOVIN_MAIN_MENU);
                }
                
            }
            
            // increasing the placement count for this ad network with this location
            placementCountAppLovinMainMenu++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountChartboostMainMenu forKey:kPlacementCountAppLovinMainMenu];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
            
            // GAMEPLAY //
        case CKAdLocationGameplay:
            // set location specific vars
            
            ////////////////////
            //// CHARTBOOST ////
            ////////////////////
            
            // not the case
            if (cKLogEnabled) {
                CKLog(@"Not showing chartboost Ad at Gameplay because it's not the case.");
            }
            
            shouldShowChartboostAdAtLocation = NO;
            
            ////////////////////
            /////// ADMOB //////
            ////////////////////
            
            // checking if ad network is enabled
            if (ADMOB_ENABLED) {
                isAdMobEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is enabled");
                }
                
            } else {
                isAdMobEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nAdMob is not enabled. To use AdMob enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_ADMOB_BANNER_AT_GAMEPLAY) {
                shouldShowAdMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show AdMob Banner at Gameplay.");
                }
                
            } else {
                shouldShowAdMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show AdMob Banner at Gameplay.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountAdMobGameplay = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountAdMobGameplay];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountAdMobGameplay % ADS_FREQUENCY_ADMOB_GAMEPLAY == 0) {
                mayShowAdMobBannerAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show AdMob Banner at Gameplay because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobGameplay, (long)ADS_FREQUENCY_ADMOB_GAMEPLAY);
                }
                
            } else {
                mayShowAdMobBannerAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show AdMob Banner at Gameplay because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobGameplay, (long)ADS_FREQUENCY_ADMOB_GAMEPLAY);
                }
                
            }
            
            
            // increasing the placement count for this ad network with this location
            placementCountAdMobGameplay++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountAdMobGameplay forKey:kPlacementCountAdMobGameplay];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            ////// REVMOB //////
            ////////////////////
            
            // NO RevMob Ads are triggered to be shown at the lauch of Gameplay
            
            ////////////////////
            ///// APPLOVIN /////
            ////////////////////
            
            // NO AppLovin Ads are triggered to be shown at the lauch of Gameplay
            
            break;
            
            // GAME OVER //
        case CKAdLocationGameOver:
            // set location specific vars
            
            ////////////////////
            //// CHARTBOOST ////
            ////////////////////
            
            // checking if ad network is enabled
            if (CHARTBOOST_ENABLED) {
                isChartboostEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"Chartboost is enabled");
                }
                
            } else {
                isChartboostEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"Chartboost is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nChartboost is not enabled. To use Chartboost enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_CHARTBOOST_INTERSTITIAL_AT_GAME_OVER) {
                shouldShowChartboostAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show Chartboost Ad at Game Over.");
                }
                
            } else {
                shouldShowChartboostAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show Chartboost Ad at Game Over.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountChartboostGameOver = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountChartboostGameOver];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountChartboostGameOver % ADS_FREQUENCY_CHARTBOOST_GAME_OVER == 0) {
                mayShowChartboostAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show Chartboost Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountChartboostGameOver, (long)ADS_FREQUENCY_CHARTBOOST_GAME_OVER);
                }
                
            } else {
                mayShowChartboostAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show Chartboost Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountChartboostGameOver, (long)ADS_FREQUENCY_CHARTBOOST_GAME_OVER);
                }
                
            }
            
            // setting up chartboost location name
            chartboostAdLocation = CBLocationGameOver;
            
            // increasing the placement count for this ad network with this location
            placementCountChartboostGameOver++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountChartboostGameOver forKey:kPlacementCountChartboostGameOver];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            /////// ADMOB //////
            ////////////////////
            
            // checking if ad network is enabled
            if (ADMOB_ENABLED) {
                isAdMobEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is enabled");
                }
                
            } else {
                isAdMobEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"AdMob is disabled");
                }
                
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nAdMob is not enabled. To use AdMob enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_ADMOB_BANNER_AT_GAME_OVER) {
                shouldShowAdMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show AdMob Banner at Game Over.");
                }
                
            } else {
                shouldShowAdMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show AdMob Banner at Game Over.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountAdMobGameOver = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountAdMobGameOver];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountAdMobGameOver % ADS_FREQUENCY_ADMOB_GAME_OVER == 0) {
                mayShowAdMobBannerAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show AdMob Banner at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobGameOver, (long)ADS_FREQUENCY_ADMOB_GAME_OVER);
                }
                
            } else {
                mayShowAdMobBannerAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show AdMob Banner at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountAdMobGameOver, (long)ADS_FREQUENCY_ADMOB_GAME_OVER);
                }
                
            }
            
            
            // increasing the placement count for this ad network with this location
            placementCountAdMobGameOver++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountAdMobGameOver forKey:kPlacementCountAdMobGameOver];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ////////////////////
            ////// REVMOB //////
            ////////////////////
            
            // checking if ad network is enabled
            if (REVMOB_ENABLED) {
                isRevMobEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"RevMob is enabled");
                }
                
            } else {
                isRevMobEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"RevMob is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nRevMob is not enabled. To use RevMob enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_REVMOB_INTERSTITIAL_AT_GAME_OVER || SHOW_REVMOB_POPUP_AT_GAME_OVER) {
                shouldShowRevMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show RevMob Ad at Game Over.");
                }
                
            } else {
                shouldShowRevMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show RevMob Ad at Game Over.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountRevMobGameOver = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountRevMobGameOver];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountRevMobGameOver % ADS_FREQUENCY_REVMOB_GAME_OVER == 0) {
                mayShowRevMobAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show RevMob Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountRevMobGameOver, (long)ADS_FREQUENCY_REVMOB_GAME_OVER);
                }
                
            } else {
                mayShowRevMobAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show RevMob Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountRevMobGameOver, (long)ADS_FREQUENCY_REVMOB_GAME_OVER);
                }
                
            }
            
            // increasing the placement count for this ad network with this location
            placementCountRevMobGameOver++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountRevMobMainMenu forKey:kPlacementCountRevMobGameOver];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            ////////////////////
            ///// APPLOVIN /////
            ////////////////////
            
            // checking if ad network is enabled
            if (APPLOVIN_ENABLED) {
                isAppLovinEnabled = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"Applovin is enabled");
                }
                
            } else {
                isAppLovinEnabled = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"AppLovin is disabled");
                }
                /*
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                 message:@"\nAppLovin is not enabled. To use AppLovin enable it."
                 delegate:nil
                 cancelButtonTitle:@"Got it"
                 otherButtonTitles:nil];
                 
                 [message show];
                 */
            }
            
            // checking if showing an ad for this ad network at this location is set to YES
            if (SHOW_APPLOVIN_INTERSTITIAL_AT_GAME_OVER) {
                shouldShowAppLovinAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App should show AppLovin Ad at Game Over.");
                }
                
            } else {
                shouldShowAppLovinAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App should NOT show AppLovin Ad at Game Over.");
                }
                
            }
            
            // getting placement count for this ad network at this location
            placementCountAppLovinGameOver = [[NSUserDefaults standardUserDefaults] integerForKey:kPlacementCountAppLovinGameOver];
            
            // checking if an ad may be shown due to ads frequency for this ad network and this location
            if (placementCountAppLovinGameOver % ADS_FREQUENCY_APPLOVIN_GAME_OVER == 0) {
                mayShowAppLovinAdAtLocation = YES;
                
                if (cKLogEnabled) {
                    CKLog(@"App may show AppLovin Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountAppLovinGameOver, (long)ADS_FREQUENCY_APPLOVIN_GAME_OVER);
                }
                
            } else {
                mayShowAppLovinAdAtLocation = NO;
                
                if (cKLogEnabled) {
                    CKLog(@"App may NOT show AppLovin Ad at Game Over because placement count is %li and ads frequency at this location is %li.", (long)placementCountAppLovinGameOver, (long)ADS_FREQUENCY_APPLOVIN_GAME_OVER);
                }
                
            }
            
            // increasing the placement count for this ad network with this location
            placementCountAppLovinGameOver++;
            [[NSUserDefaults standardUserDefaults] setInteger:placementCountChartboostMainMenu forKey:kPlacementCountAppLovinGameOver];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
            
        default:
            break;
    }
    
    ///////////////////////
    //// SHOWING ADS //////
    ///////////////////////
    
    // Chartboost
    
    if (isChartboostEnabled & shouldShowChartboostAdAtLocation & mayShowChartboostAdAtLocation) {
        // checking if Chartboost IDs are set
        /*if ([CHARTBOOST_APP_ID  isEqual: kChupamobileChartboostAppID] || [CHARTBOOST_APP_SIGNATURE  isEqual: kChupamobileChartboostAppSignature]) {
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to show a Chartboost ad here but have not set up your Chartboost IDs. Please, set them up."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         }*/
        //else {
        if (cKLogEnabled) {
            CKLog(@"Starting to show Chartboost Ad.");
        }
        
        // show the ad
        [Chartboost showInterstitial:chartboostAdLocation];
        
        if (chartboostAdLocation == CKAdLocationMainMenu) {
            // preparing string to send
            NSInteger adCount = [self getAdCountForPlace:kAdCountChartboostMainMenu];
            adCount++;
            whatStringToSend = [NSString stringWithFormat:@"Chartboost.MainMenu.%ld",(long)adCount];
            // write to file
            [self writeToFileTheMethodThatWasCalled:whatStringToSend];
            // saving current adcount
            [self setAdCount:adCount forPlace:kAdCountChartboostMainMenu];
        } else {
            // preparing string to send
            NSInteger adCount = [self getAdCountForPlace:kAdCountChartboostGameOver];
            adCount++;
            whatStringToSend = [NSString stringWithFormat:@"Chartboost.GameEnd.%ld",(long)adCount];
            // write to file
            [self writeToFileTheMethodThatWasCalled:whatStringToSend];
            // saving current adcount
            [self setAdCount:adCount forPlace:kAdCountChartboostGameOver];
        }
        
        // Cache interstitial
        if (![Chartboost hasInterstitial:chartboostAdLocation]) {
            [Chartboost cacheInterstitial:chartboostAdLocation];
        }
    }
    
    // }
    
    // AdMob
    if (isAdMobEnabled & shouldShowAdMobAdAtLocation & mayShowAdMobBannerAdAtLocation) {
        if (cKLogEnabled) {
            CKLog(@"Starting to show AdMob Ad.");
        }
        
        [self showAdMobAdAt:cKAdLocation forViewController:viewController];
        
    }
    
    // RevMob
    if (isRevMobEnabled & shouldShowRevMobAdAtLocation & mayShowRevMobAdAtLocation) {
        
        // checking if RevMob Media ID ais set
        /*if ([REVMOB_MEDIA_ID  isEqual: kChupamobileRevMobMediaID]) {
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to show a RevMob ad here but have not set up your RevMob Media ID. Please, set it up."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         } else {
         */
        // RevMob starts the session pretty slow
        // the ads are called before their server may start the session so
        // if the ad is called at Main Menu (banner ads are Main Menu only) we get an error in the log: [RevMob] Warning: RevMob session was not started
        // the workaround for this problem is to wait for a few seconds before asking for ads
        // wait time is set to 4 seconds, tweak at will
        NSInteger waitTime = 4;
        if (cKLogEnabled) {
            CKLog(@"Waiting RevMob to start session. Starting to show RevMob Ad in %li seconds...", (long)waitTime);
        }
        
        dispatch_after_delta(waitTime, ^{
            
            if (cKLogEnabled) {
                CKLog(@"Starting to show RevMob Ad.");
            }
            
            switch (cKAdLocation) {
                case CKAdLocationMainMenu:
                    
                    if (SHOW_REVMOB_BANNER_AT_MAIN_MENU) {
                        //starting to show RevMob Banner Ad at Main Menu
                        if (cKLogEnabled) {
                            CKLog(@"Starting to show RevMob Banner Ad at Main Menu.");
                        }
                        
                        [[RevMobAds session] showBanner];
                    }
                    if (SHOW_REVMOB_INTERSTITIAL_AT_MAIN_MENU) {
                        //starting to show RevMob Interstitial Ad at Main Menu
                        if (cKLogEnabled) {
                            CKLog(@"Starting to show RevMob Interstitial Ad at Main Menu.");
                        }
                        
                        [[RevMobAds session] showFullscreen];
                        
                    }
                    if (SHOW_REVMOB_POPUP_AT_MAIN_MENU) {
                        //starting to show RevMob Popup Ad at Main Menu
                        if (cKLogEnabled) {
                            CKLog(@"Starting to show RevMob Popup Ad at Main Menu.");
                        }
                        
                        [[RevMobAds session] showPopup];
                    }
                    
                    // preparing string to send
                    NSInteger adCount = [self getAdCountForPlace:kAdCountRevMobMainMenu];
                    adCount++;
                    whatStringToSend = [NSString stringWithFormat:@"RevMob.MainMenu.%ld",(long)adCount];
                    // write to file
                    [self writeToFileTheMethodThatWasCalled:whatStringToSend];
                    // saving current adcount
                    [self setAdCount:adCount forPlace:kAdCountRevMobMainMenu];
                    
                    break;
                    
                case CKAdLocationGameOver:
                    
                    if (SHOW_REVMOB_INTERSTITIAL_AT_GAME_OVER) {
                        //starting to show RevMob Interstitial Ad at Game Over
                        if (cKLogEnabled) {
                            CKLog(@"Starting to show RevMob Interstitial Ad at Game Over.");
                        }
                        
                        [[RevMobAds session] showFullscreen];
                        
                    }
                    if (SHOW_REVMOB_POPUP_AT_GAME_OVER) {
                        //starting to show RevMob Popup Ad at Game Over
                        if (cKLogEnabled) {
                            CKLog(@"Starting to show RevMob Popup Ad at Game Over.");
                        }
                        
                        [[RevMobAds session] showPopup];
                    }
                    
                    // preparing string to send
                    NSInteger adCount2 = [self getAdCountForPlace:kAdCountRevMobGameOver];
                    adCount2++;
                    whatStringToSend = [NSString stringWithFormat:@"RevMob.GameEnd.%ld",(long)adCount2];
                    // write to file
                    [self writeToFileTheMethodThatWasCalled:whatStringToSend];
                    // saving current adcount
                    [self setAdCount:adCount2 forPlace:kAdCountRevMobGameOver];
                    
                    break;
                    
                default:
                    break;
            }
        });
        
        //}
        
    }
    
    //AppLovin
    if (isAppLovinEnabled & shouldShowAppLovinAdAtLocation & mayShowAppLovinAdAtLocation) {
        
        // checking if RevMob Media ID ais set
        /*if ([APPLOVIN_SDK_KEY  isEqual: kChupamobileAppLovinSdkKey]) {
         
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to show an AppLovin ad here but have not set up your AppLovin Sdk Key. Please, set it up in the Info.plist file."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         } else {
         */
        if (cKLogEnabled) {
            CKLog(@"Starting to show Applovin Ad.");
        }
        
        switch (cKAdLocation) {
            case CKAdLocationMainMenu:
                
                if (SHOW_APPLOVIN_INTERSTITIAL_AT_MAIN_MENU) {
                    //starting to show RevMob Banner Ad at Main Menu
                    if (cKLogEnabled) {
                        CKLog(@"Starting to show AppLovin Interstitial Ad at Main Menu.");
                    }
                    
                    // showing AppLovin Interstitial
                    ALInterstitialAd* inter = [[ALInterstitialAd alloc] initWithSdk: appLovinSdk];
                    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
                    [inter showOver: keyWindow];
                    
                    // preparing string to send
                    NSInteger adCount = [self getAdCountForPlace:kAdCountAppLovinMainMenu];
                    adCount++;
                    whatStringToSend = [NSString stringWithFormat:@"Applovin.MainMenu.%ld",(long)adCount];
                    // write to file
                    [self writeToFileTheMethodThatWasCalled:whatStringToSend];
                    // saving current adcount
                    [self setAdCount:adCount forPlace:kAdCountAppLovinMainMenu];
                    
                }
                
                break;
                
            case CKAdLocationGameOver:
                
                if (SHOW_APPLOVIN_INTERSTITIAL_AT_GAME_OVER) {
                    //starting to show RevMob Interstitial Ad at Game Over
                    if (cKLogEnabled) {
                        CKLog(@"Starting to show AppLovin Interstitial Ad at Game Over.");
                    }
                    
                    // showing AppLovin Interstitial
                    ALInterstitialAd* inter = [[ALInterstitialAd alloc] initWithSdk: appLovinSdk];
                    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
                    [inter showOver: keyWindow];
                    
                    // preparing string to send
                    NSInteger adCount = [self getAdCountForPlace:kAdCountAppLovinGameOver];
                    adCount++;
                    whatStringToSend = [NSString stringWithFormat:@"Applovin.GameEnd.%ld",(long)adCount];
                    // write to file
                    [self writeToFileTheMethodThatWasCalled:whatStringToSend];
                    // saving current adcount
                    [self setAdCount:adCount forPlace:kAdCountAppLovinGameOver];
                }
                
                break;
                
            default:
                break;
        }
        
        //}
        
    }
    
}
//Hide Banner
- (void) hideBanner
{
    //Hide Admob banner
    [bannerView_ removeFromSuperview];
    
    //Hide RevMob banner
    [[RevMobAds session] hideBanner];
    
}

// helpers for getting and setting ad counts
- (NSInteger) getAdCountForPlace: (NSString*) placeKey {
    return [[NSUserDefaults standardUserDefaults] integerForKey:placeKey];
}

- (void) setAdCount: (NSInteger) adCount forPlace: (NSString*) placeKey {
    [[NSUserDefaults standardUserDefaults] setInteger:adCount forKey:placeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) enableChupamobileKitLog: (BOOL) condition {
    [[NSUserDefaults standardUserDefaults] setBool:condition forKey:kEnableDisableChupamobileKitLog];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isChupamobileKitLogEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kEnableDisableChupamobileKitLog];
}

- (void) enableAdMobTestMode: (BOOL) condition {
    [[NSUserDefaults standardUserDefaults] setBool:condition forKey:kEnableDisableAdMobTestMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isAdMobTestModeEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kEnableDisableAdMobTestMode];
}


- (void) setAdMobTestIDForFirstDevice:(NSString*) adMobTestDeviceID {
    
    [[NSUserDefaults standardUserDefaults] setObject:adMobTestDeviceID forKey:kAdMobTestIDForFirstDevice];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) adMobTestIDForFirstDevice {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAdMobTestIDForFirstDevice];
}

- (void) setAdMobTestIDForSecondDevice:(NSString*) adMobTestDeviceID {
    [[NSUserDefaults standardUserDefaults] setObject:adMobTestDeviceID forKey:kAdMobTestIDForSecondDevice];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) adMobTestIDForSecondDevice {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAdMobTestIDForSecondDevice];
}

- (void) showChartboostMoreApps {
    
    if (CHARTBOOST_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"Chartboost is enabled. Showing Chartboost More Apps.");
        }
        
        if (AUTHOR_MODE) {
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                              message:@"\nDear developer,\n Congratulations on placing the More Apps Page here!\n Consider this popup as the More Apps Page.\n\n Your work is done here."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Got it"
                                                    otherButtonTitles:nil];
            
            [message show];
            
            return;
        }
        
        // checking if Chartboost IDs are set
         if ([CHARTBOOST_APP_ID  isEqual: kChupamobileChartboostAppID] || [CHARTBOOST_APP_SIGNATURE  isEqual: kChupamobileChartboostAppSignature]) {
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to use the Chartboost More Apps Page but have not set up your Chartboost IDs. Please, set them up."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         } else {
        // Show more apps
        [Chartboost showMoreApps:CBLocationSettings];
        
        // Cache more apps
        if (![Chartboost hasMoreApps:CBLocationSettings]) {
            [Chartboost cacheMoreApps:CBLocationSettings];
        }
        }
        
    } else {
        if (cKLogEnabled) {
            CKLog(@"Chartboost is NOT enabled. Not Showing Chartboost More Apps.");
            /*
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\nChartboost is NOT enabled. Not Showing Chartboost More Apps. To show the More Apps Page please enable Chartboost."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
             */
        }
    }
}

- (void) logFlurryEventWithName:(NSString*) eventName {
    
    if (FLURRY_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"Flurry is enabled.");
        }
        
        // checking if Flurry API Key is set
        /*if ([FLURRY_API_KEY isEqual:kChupamobileFlurryAPIKey]) {
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to log a Flurry Event but have not set up your Flurry API Key. Please, set it up."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         } else {*/
        if (cKLogEnabled) {
            CKLog(@"Flurry API Key is set. Logging Flurry Event with name: > %@ <", eventName);
        }
        // logging Flurry event
        [Flurry logEvent:eventName];
        //}
        
    } else {
        if (cKLogEnabled) {
            CKLog(@"Flurry is NOT enabled.");
            
            
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\nYou want to use Flurry Analytics but Flurry is NOT enabled. Please, enable it."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
            
        }
    }
}

- (void) startNextpeerMultiplayerGame {
    
    if (NEXTPEER_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is enabled.");
        }
        
        if (AUTHOR_MODE) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                              message:@"\nDear developer,\n Set up Nextpeer! (if you haven't already done so)\n Please, follow the Tutorial from the Log.\n\n If you did set up Nextpeer according to the log than you may safely disregard this alert.\n\n If you wish to test Nextpeer: go to ChupamobileKit/ ChupamobileKitSettings.plist and add your Nextpeer Game Key to the field with the same name. Than set `Nextpeer Enabled` to YES. After testing make sure you change back the `Nextpeer Game Key` value to `999999`. Thanks."
                                                             delegate:nil
                                                    cancelButtonTitle:@"Got it"
                                                    otherButtonTitles:nil];
            
            [message show];
            
            NSLog(@"<-------------------------- CHUPAMOBILE KIT TUTORIAL -------------------------->");
            NSLog(@"IMPORTANT: Please set up Nextpeer (if you haven't already done so)");
            NSLog(@"Here's what you have to do:");
            NSLog(@"1. Add your code to start the gameplay in the >startMultiPlayerGame:< method in the AppDelegate.m file (at the warning)");
            NSLog(@"   This will ensure that once the user starts a multiplayer game from the Nextpeer Dashboard your gameplay will start.");
            NSLog(@"   The code should be exactly like starting a single player gameplay.");
            NSLog(@"2. Start the multiplayer game with the >startNextpeerMultiplayerGame< method at a button of your choice.");
            NSLog(@"   Simply add this line at the button you want the Multiplayer Game to begin: ");
            NSLog(@"   Obj-C: [[ChupamobileKit sharedKit] startNextpeerMultiplayerGame]; ");
            NSLog(@"   Swift: ChupamobileKit.sharedKit().startNextpeerMultiplayerGame() ");
            NSLog(@"3. Register current score (i.e. when picking up a coin) with the >reportNextpeerScore:< method in the flow of your gameplay.");
            NSLog(@"   Simply add this line where a new score is gained: ");
            NSLog(@"   Obj-C: [[ChupamobileKit sharedKit] reportNextpeerScore:currentScore]; ");
            NSLog(@"   Swift: ChupamobileKit.sharedKit().reportNextpeerScore(currentScore) ");
            NSLog(@"   Here >currentScore< has to be an uint32_t variable.");
            NSLog(@"4. End multiplayer game with the >endNextpeerMultiplayerGameAndReportScore:< method.");
            NSLog(@"   Simply add this line when your gameplay is over:");
            NSLog(@"   Obj-C: [ChupamobileKit sharedKit] endNextpeerMultiplayerGameAndReportScore:currentScore];");
            NSLog(@"   Swift: ChupamobileKit.sharedKit().endNextpeerMultiplayerGameAndReportScore(currentScore)");
            NSLog(@"   Here currentScore has to be an uint32_t variable.");
            NSLog(@"   These are all the steps you have to take. Your work is done here.");
            NSLog(@"<-------------------------- CHUPAMOBILE KIT TUTORIAL - END -------------------------->");
        }
        
        // checking if Nextpeer Game Key is set
         if (!AUTHOR_MODE & [NEXTPEER_GAME_KEY isEqual:kChupamobileNextpeerGameKey]) {
         if (!AUTHOR_MODE) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to use Nextpeer but have not set up your Nextpeer Game Key. Please, set it up."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         } else {
         
        CKLog(@"Nextpeer Game Key is set. Launching Nextpeer Dashboard.");
        
       // [Nextpeer launchDashboard];
        
        }
        
    } else {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is NOT enabled.");
            /*
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\n Nextpeer is disabled!\n To use Nextpeer enable it."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
             */
        }
    }
}

- (void) reportNextpeerScore:(uint32_t) currentScore {
    if (NEXTPEER_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is enabled. Reporting score: %i", currentScore);
        }
        
     /*   if ([Nextpeer isCurrentlyInTournament]) {
            
            // Report the score to Nextpeer
            [Nextpeer reportScoreForCurrentTournament:currentScore];
        }
       */
    } else {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is NOT enabled.");
        }
    }
}

- (void) endNextpeerMultiplayerGameAndReportScore:(uint32_t) currentScore {
    if (NEXTPEER_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is enabled. Ending multiplayer game and reporting score: %i", currentScore);
        }
        
       /* if ([Nextpeer isCurrentlyInTournament]) {
            
            // ending Nextpeer tournament
            [Nextpeer reportControlledTournamentOverWithScore:currentScore];
        }*/
        
    } else {
        if (cKLogEnabled) {
            CKLog(@"Nextpeer is NOT enabled.");
        }
    }
}

- (void) enableiRateTestModeWithTestAppID: (NSInteger) testAppID andTestAppBundleID: (NSString*) testAppBundleID {
    
    if (IRATE_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"iRate is enabled. Setting iRate Preview Mode with app ID: %li and bundle ID: %@",(long)testAppID, testAppBundleID);
        }
        
        /*if (!AUTHOR_MODE) {
         if (testAppID == kChupamobileiRateTestAppID) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to test the Rate System but you haven't set up your Test App ID!\n Set it up at the top of the AppDelegate file."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         
         if ([testAppBundleID  isEqual: kChupamobileiRateTestAppBundleID]) {
         UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
         message:@"\nYou want to test the Rate System but you haven't set up your Test App Bundle ID!\n Set it up at the top of the AppDelegate file."
         delegate:nil
         cancelButtonTitle:@"Got it"
         otherButtonTitles:nil];
         
         [message show];
         }
         }
         */
        //enable preview mode
        [iRate sharedInstance].previewMode = YES;
        [iRate sharedInstance].appStoreID = testAppID;
        [iRate sharedInstance].applicationBundleID = testAppBundleID;
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\nYou want to test the Rate System but it is disabled!\n To use the Rate System enable it."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }
}

- (void) rateApp {
    
    if (AUTHOR_MODE) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\nDear developer,\n Congratulations on placing a rate button here!\n Consider this popup as the App Store page of the app where users can rate.\n\n Your work is done here."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
        
        return;
    }
    
    if (IRATE_ENABLED) {
        if (cKLogEnabled) {
            CKLog(@"iRate is enabled. Going to app on App Store.");
        }
        
        NSLog(@"You've just tapped the Rate Button. If your app is not already on the app store than nothing will really happen besides this log. Don't worry, once your app is on the App Store you will be taken to the page of the app on the App Store.");
        
        [[iRate sharedInstance] openRatingsPageInAppStore];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\n Rate is disabled!\n To use Rate enable it."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    
}

- (void) showAdMobAdAt:(CKAdLocation) cKAdLocation forViewController: (UIViewController*) viewController {
    
    BOOL shouldShowAdMobBannerAtMainMenu = YES;
    BOOL shouldShowAdMobBannerAtGameplay = YES;
    BOOL shouldShowAdMobBannerAtGameOver = YES;
    if (AUTHOR_MODE) {
        NSLog(@"Author Mode = TRUE");
        
    } else {
        NSLog(@"Author Mode = FALSE");
    }

    switch (cKAdLocation) {
        case CKAdLocationMainMenu:
            
            
             if (!AUTHOR_MODE && [ADMOD_BANNER_MAIN_MENU_ID  isEqual: kChupamobileAdMobBannerID]) {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\n Can't show AdMob Banner at Main Menu because your AdMob Banner ID is not set up for this placement!\n Please set it up."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
             
             shouldShowAdMobBannerAtMainMenu = NO;
             
             } else {
            adLocationName = @"Main Menu";
            //adMobAdUnitID = ADMOD_BANNER_MAIN_MENU_ID;
            adMobAdUnitID = [[NSUserDefaults standardUserDefaults] objectForKey:kAdMobBannerMainMenuID];
            
            
            if (ADMOB_BANNER_MAIN_MENU_IS_AT_BOTTOM) {
                adMobBannerType = kAdmobBannerPortraitBottom;
            } else {
                adMobBannerType = kAdMobBannerPortraitTop;
            }
            }
            
            break;
            
        case CKAdLocationGameplay:
            
            if (!AUTHOR_MODE & [ADMOD_BANNER_GAMEPLAY_ID  isEqual: kChupamobileAdMobBannerID]) {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\n Can't show AdMob Banner at Gameplay because your AdMob Banner ID is not set up for this placement!\n Please set it up."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
             
             shouldShowAdMobBannerAtGameplay = NO;
             
             } else {
            adLocationName = @"Gameplay";
            //adMobAdUnitID = ADMOD_BANNER_GAMEPLAY_ID;
            adMobAdUnitID = [[NSUserDefaults standardUserDefaults] objectForKey:kAdMobBannerGameplayID];
            
            if (ADMOB_BANNER_GAMEPLAY_IS_AT_BOTTOM) {
                adMobBannerType = kAdmobBannerPortraitBottom;
            } else {
                adMobBannerType = kAdMobBannerPortraitTop;
            }
            }
            
            break;
            
        case CKAdLocationGameOver:
            
            if (!AUTHOR_MODE & [ADMOD_BANNER_GAME_OVER_ID  isEqual: kChupamobileAdMobBannerID]) {
             UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
             message:@"\n Can't show AdMob Banner at Game Over because your AdMob Banner ID is not set up for this placement!\n Please set it up."
             delegate:nil
             cancelButtonTitle:@"Got it"
             otherButtonTitles:nil];
             
             [message show];
             
             shouldShowAdMobBannerAtGameOver = NO;
             
             } else {
            adLocationName = @"Game Over";
            //adMobAdUnitID = ADMOD_BANNER_GAME_OVER_ID;
            adMobAdUnitID = [[NSUserDefaults standardUserDefaults] objectForKey:kAdMobBannerGameOverID];
            
            if (ADMOB_BANNER_GAME_OVER_IS_AT_BOTTOM) {
                adMobBannerType = kAdmobBannerPortraitBottom;
            } else {
                adMobBannerType = kAdMobBannerPortraitTop;
            }
            }
            
            break;
            
        default:
            break;
    }
    
    // breaking the request for a banner if the ID's are not set up
    if ((cKAdLocation == CKAdLocationMainMenu) & !shouldShowAdMobBannerAtMainMenu) {
        return;
    }
    
    if ((cKAdLocation == CKAdLocationGameplay) & !shouldShowAdMobBannerAtGameplay) {
        return;
    }
    
    if ((cKAdLocation == CKAdLocationGameOver) & !shouldShowAdMobBannerAtGameOver) {
        return;
    }
    
    if (bannerView_) {
        
        NSLog(@"Removing current AdMob Banner.");
        
        [bannerView_ removeFromSuperview];
        bannerView_ = nil;
        
        NSLog(@"Showing AdMob Banner at %@.",adLocationName);
    } else {
        NSLog(@"Showing AdMob Banner at %@ for the first time since launching the app.", adLocationName);
    }
    
    // checking device orientation
    if (isOrientationPortrait)
    {
        bannerSize = kGADAdSizeSmartBannerPortrait;
        
        if (IS_IPHONE) {
            theViewSize = CGSizeMake(320, 480);
        }
        
        if (IS_IPAD) {
            theViewSize = CGSizeMake(768, 1024);
        }
        
        
        if (IS_IPHONE_5) {
            theViewSize = CGSizeMake(320, 568);
        }
        
        if (IS_IPHONE_6) {
            theViewSize = CGSizeMake(375, 667);
        }
        
        if (IS_IPHONE_6_PLUS) {
            theViewSize = CGSizeMake(414, 736);
        }
        
        NSLog(@"View Size - %f. x %f.", theViewSize.width, theViewSize.height);
        
    } else {
        bannerSize = kGADAdSizeSmartBannerLandscape;
        
        if (IS_IPHONE) {
            theViewSize = CGSizeMake(480, 320);
        }
        
        if (IS_IPAD) {
            theViewSize = CGSizeMake(1024, 768);
        }
        
        if (IS_IPHONE_5) {
            theViewSize = CGSizeMake(568, 320);
        }
        
        if (IS_IPHONE_6) {
            theViewSize = CGSizeMake(667, 375);
        }
        
        if (IS_IPHONE_6_PLUS) {
            theViewSize = CGSizeMake(736, 414);
        }
        
        NSLog(@"Viev Size - %f. x %f.", theViewSize.width, theViewSize.height);
        
    }
    
    
    
    bannerView_ = [[GADBannerView alloc] initWithAdSize:bannerSize];
    bannerView_.adUnitID = adMobAdUnitID;
    //bannerView_.rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    bannerView_.rootViewController = viewController;
    //bannerView_.tag = 1;
    //[[[UIApplication sharedApplication] keyWindow] addSubview:bannerView_];
    [viewController.view addSubview:bannerView_];
    GADRequest *request = [GADRequest request];
    
    if (self.isAdMobTestModeEnabled) {
        // Make the request for a test ad. Put in an identifier for
        // the simulator as well as any devices you want to receive test ads.
        request.testDevices = @[ GAD_SIMULATOR_ID, [[OneSDK sharedSDK] adMobTestIDForFirstDevice], [[OneSDK sharedSDK] adMobTestIDForSecondDevice] ];
        
    }
    
    
    
    [bannerView_ loadRequest:request];
    
    CGRect frame = bannerView_.frame;
    
    adMobBannerPosition_x = 0.0f;
    
    switch (adMobBannerType)
    {
        case kAdMobBannerPortraitTop:
        {
            adMobBannerPosition_y = 0.0f;
        }
            break;
        case kAdmobBannerPortraitBottom:
        {
            adMobBannerPosition_y = theViewSize.height-frame.size.height;
        }
            break;
        case kAdMobBannerLandscapeTop:
        {
            adMobBannerPosition_y = 0.0f;
        }
            break;
        case kAdMobBannerLandscapeBottom:
        {
            adMobBannerPosition_y = theViewSize.height-frame.size.height;
        }
            break;
            
        default:
            break;
    }
    
    frame.origin.x = adMobBannerPosition_x;
    frame.origin.y = adMobBannerPosition_y;
    
    bannerView_.frame = frame;
    
    //sending ad count info with logger
    if (cKAdLocation == CKAdLocationMainMenu) {
        // preparing string to send
        NSInteger adCount = [self getAdCountForPlace:kAdCountAdMobMainMenu];
        adCount++;
        whatStringToSend = [NSString stringWithFormat:@"AdMob.MainMenu.%ld",(long)adCount];
        // write to file
        [self writeToFileTheMethodThatWasCalled:whatStringToSend];
        // saving current adcount
        [self setAdCount:adCount forPlace:kAdCountAdMobMainMenu];
    }
    
    if (cKAdLocation == CKAdLocationGameplay) {
        // preparing string to send
        NSInteger adCount = [self getAdCountForPlace:kAdCountAdMobGameplay];
        adCount++;
        whatStringToSend = [NSString stringWithFormat:@"AdMob.Gameplay.%ld",(long)adCount];
        // write to file
        [self writeToFileTheMethodThatWasCalled:whatStringToSend];
        // saving current adcount
        [self setAdCount:adCount forPlace:kAdCountChartboostGameOver];
    }
    
    if (cKAdLocation == CKAdLocationGameOver) {
        // preparing string to send
        NSInteger adCount = [self getAdCountForPlace:kAdCountAdMobGameOver];
        adCount++;
        whatStringToSend = [NSString stringWithFormat:@"AdMob.GameEnd.%ld",(long)adCount];
        // write to file
        [self writeToFileTheMethodThatWasCalled:whatStringToSend];
        // saving current adcount
        [self setAdCount:adCount forPlace:kAdCountAdMobGameOver];
    }
    
    
}

- (void) setupiRate {
    
    // disable preview mode by default
    [iRate sharedInstance].previewMode = NO;
    
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = IRATE_DAYS_UNTIL_PROMPT;
    [iRate sharedInstance].usesUntilPrompt = IRATE_USES_UNTIL_PROMPT;
    [iRate sharedInstance].onlyPromptIfLatestVersion = YES;
    [iRate sharedInstance].remindPeriod = IRATE_REMIND_PERIOD;
    
    //overriding the default iRate strings
    [iRate sharedInstance].messageTitle = NSLocalizedString(IRATE_PROMPT_TITLE, @"iRate message title");
    [iRate sharedInstance].message = NSLocalizedString(IRATE_PROMPT_MESSAGE, @"iRate message");
    
}

- (void) removeAds {
    if (bannerView_) {
        
        NSLog(@"Removing current AdMob Banner.");
        
        [bannerView_ removeFromSuperview];
        bannerView_ = nil;
        
    }
    
    //Remove RevMob banner
    [[RevMobAds session] hideBanner];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAdsAreRemoved];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (AUTHOR_MODE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\nYou have just purchased the `No Ads` IAP. All ads are removed and none will be shown in the future."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

- (BOOL) areAdsRemoved {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAdsAreRemoved];
}

- (void) writeToFileTheMethodThatWasCalled: (NSString *) nameOfTheMethod{
    //    //delete plist file
    //    [[NSFileManager defaultManager] removeItemAtPath:self.pathForChupamobileHistoryPlist error:NULL];
    //
    //    //reset counterForTheMethodPlistKey and empty the plist
    //    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"counterForTheMethodPlistKey"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"] != nil )
    {
        // app already launched
        NSLog(@"App was allredy launched");
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"counterForTheMethodPlistKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        NSLog(@"FIRST LAUNCH");
        
    }
    
    int counterForMethodKey = [[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"];
    counterForMethodKey++;
    [[NSUserDefaults standardUserDefaults] setInteger:counterForMethodKey forKey:@"counterForTheMethodPlistKey"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"CounterForMethodKey is: %d",counterForMethodKey);
    
    
    
    //CREATE PLIST
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    self.pathForChupamobileHistoryPlist = [documentsDirectory stringByAppendingPathComponent:@"ChupamobileHistoryPlist.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //IF IT DOES NOT EXIST ALLREADY
    if (![fileManager fileExistsAtPath: self.pathForChupamobileHistoryPlist]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"ChupamobileHistoryPlist" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: self.pathForChupamobileHistoryPlist error:&error]; //6
    }
    
    
    
    
    
    //get the time for the called method
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [NSDate date];
    NSString *currentTimeString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    
    //READ THE ChupamobileKitSettingsPlist
    NSArray *pathOfChupamobileKitSettingsPlist = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectoryOfChupamobileKitSettingsPlist = [paths objectAtIndex:0]; //2
    NSString *path2 = [documentsDirectoryOfChupamobileKitSettingsPlist stringByAppendingPathComponent:@"ChupamobileKitSettings.plist"]; //3
    NSMutableArray *savedStock = [[NSMutableArray alloc] initWithContentsOfFile: path2];
    NSMutableDictionary *dictionaryWithContent = [[NSMutableDictionary alloc]init];
    dictionaryWithContent = [savedStock objectAtIndex:0];
    NSString *api_id = [dictionaryWithContent objectForKey:@"apiID"] ;
    NSLog(@"The api_id is: %@",api_id);
    NSString *api_key = [dictionaryWithContent objectForKey:@"apiKey"] ;
    NSLog(@"The api_id is: %@",api_key);
    
    //Operating Sytem
    NSString *operatingSystem = @"IOS";
    
    //Get os version
    double ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *OSVersion = [NSString stringWithFormat:@"%.2f", ver];
    NSLog(@"OS VERSION IS: %@", OSVersion);
    
    
    
    //WRITE TO PLIST
    NSMutableDictionary *dataForChupamobileHistoryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile: self.pathForChupamobileHistoryPlist];
    
    //here add elements to data file and write data to file
    NSMutableDictionary *myDictionaryForChupamobileHistoryPlist = [[NSMutableDictionary alloc]init];
    [myDictionaryForChupamobileHistoryPlist setObject:api_id forKey:@"api_id"];
    [myDictionaryForChupamobileHistoryPlist setObject:currentTimeString forKey:@"at"];
    [myDictionaryForChupamobileHistoryPlist setObject:operatingSystem forKey:@"oS"];
    [myDictionaryForChupamobileHistoryPlist setObject:OSVersion forKey:@"ver"];
    [myDictionaryForChupamobileHistoryPlist setObject:[NSString stringWithFormat:@"%@",nameOfTheMethod] forKey:@"what"];
    
    NSLog(@"The dictionary is: %@", myDictionaryForChupamobileHistoryPlist.debugDescription);
    NSLog(@"Current possition in history plist is: %d", counterForMethodKey);
    
    NSString *keyForChupamobileHistoryPlist = [NSString stringWithFormat:@"%d", counterForMethodKey];
    
    ////
    [dataForChupamobileHistoryPlist setObject:myDictionaryForChupamobileHistoryPlist forKey:keyForChupamobileHistoryPlist];
    
    [dataForChupamobileHistoryPlist writeToFile: self.pathForChupamobileHistoryPlist atomically:YES];
    
    
    NSMutableDictionary *savedStock2 = [[NSMutableDictionary alloc] initWithContentsOfFile: self.pathForChupamobileHistoryPlist];
    
    //load from savedStock2 example int value
    NSString *value2;
    value2 = [savedStock2 objectForKey:@"value"];
    NSLog(@"The value that will be printed is: %@",value2);
    
    
}

- (void) postHistoryOnServer{
    int counterForMethodKey = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTimeTracker"];
    counterForMethodKey++;
    NSLog(@"counterForMethodKey is equal to: %d",counterForMethodKey);
    [[NSUserDefaults standardUserDefaults] setInteger:counterForMethodKey forKey:@"counterForTimeTracker"];
    if (counterForMethodKey == 15) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"] >= 1) {
            
            //encode the standard header to base 64
            NSData *HeaderEncriptionDataUsed = [@"{\"alg\":\"HS256\"}" dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64EncodedHeaderResult = [HeaderEncriptionDataUsed base64EncodedStringWithOptions:nil];
            NSLog(@"header after encripion is: %@",base64EncodedHeaderResult);
            
            //Start preparing the token.Claims
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
            NSArray *pathOfChupamobileKitSettingsPlist = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
            NSString *documentsDirectoryOfChupamobileKitSettingsPlist = [paths objectAtIndex:0]; //2
            NSString *path2 = [documentsDirectoryOfChupamobileKitSettingsPlist stringByAppendingPathComponent:@"ChupamobileKitSettings.plist"]; //3
            NSMutableArray *savedStock = [[NSMutableArray alloc] initWithContentsOfFile: path2];
            NSMutableDictionary *dictionaryWithContent = [[NSMutableDictionary alloc]init];
            dictionaryWithContent = [savedStock objectAtIndex:0];
            
            //GET API ID
            NSString *api_id = [dictionaryWithContent objectForKey:@"apiID"] ;
            //NSString *api_id = API_ID;
            NSLog(@"The api_id is: %@",api_id);
            
            //GET API KEY
            NSString *api_key = [dictionaryWithContent objectForKey:@"apiKey"] ;
            //NSString *api_key = API_KEY;
            NSLog(@"The api_key is: %@",api_key);
            
            //SET THE EXPIRATION DATE FOR POST IN UNIX FORMAT
            double expirationDateForPostMethod = [[NSDate date] timeIntervalSince1970];
            expirationDateForPostMethod = expirationDateForPostMethod + 30*60;
            NSLog(@"The expiration date is: %f", expirationDateForPostMethod);
            
            //Compose the body from the plist file
            NSMutableString *bodyContainerString = [[NSMutableString alloc]init];
            NSLog(@"The method will run until: %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"]);
            for (int countKeyInPList=1; countKeyInPList <= [[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"]; countKeyInPList++) {
                NSLog(@"enter the for loop");
                
                //read plist element one by one and add it to the mutable string
                //READ THE PLIST
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
                NSString *documentsDirectory = [paths objectAtIndex:0]; //2
                NSString *path2 = [documentsDirectory stringByAppendingPathComponent:@"ChupamobileHistoryPlist.plist"]; //3
                NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path2];
                NSString *value;
                NSString *stringFromNsUserCounter = [NSString stringWithFormat: @"%d",countKeyInPList];
                value = [savedStock objectForKey:stringFromNsUserCounter] ;
                NSString *formatStringDependingThePossition;
                if( countKeyInPList==1){
                    formatStringDependingThePossition = [NSString stringWithFormat:@"[%@,",value];
                }
                else if (countKeyInPList>1 && countKeyInPList<[[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"]) {
                    formatStringDependingThePossition = [NSString stringWithFormat:@"%@,",value];
                }
                else if (countKeyInPList == [[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTheMethodPlistKey"]) {
                    formatStringDependingThePossition = [NSString stringWithFormat:@"%@]",value];
                }
                else{
                    formatStringDependingThePossition = @"test";
                }
                [bodyContainerString appendString:formatStringDependingThePossition];
            }
            
            bodyContainerString =[bodyContainerString stringByReplacingOccurrencesOfString:@";" withString:@","];
            bodyContainerString =[bodyContainerString stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            bodyContainerString =[bodyContainerString stringByReplacingOccurrencesOfString:@" :" withString:@":"];
            bodyContainerString =[bodyContainerString stringByReplacingOccurrencesOfString:@"*\"," withString:@"\""];
            bodyContainerString =[bodyContainerString stringByReplacingOccurrencesOfString:@"\":" withString:@"\" :"];
            
            
            
            
            NSMutableString *bodyContainerString2 = [[NSMutableString alloc] init];
            bodyContainerString2 = bodyContainerString;
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@";" withString:@","];
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"=" withString:@":"];
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@" :" withString:@":"];
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"*\"," withString:@"\""];
            
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSArray* words = [bodyContainerString2 componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            bodyContainerString2 = [words componentsJoinedByString:@""];
            // bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"IOS" withString:@"\"IOS\""];
            // bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"debugger" withString:@"\"debugger\""];
            // bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"at" withString:@"\"at\""];
            // bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"oS" withString:@"\"oS\""];
            // bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"ver" withString:@"\"ver\""];
            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@"wh\"at" withString:@"\"what"];
            //            bodyContainerString2 =[bodyContainerString2 stringByReplacingOccurrencesOfString:@":\"}" withString:@":\",\"value\":\"\",\"cid\":\"1\",\"cai\":\"1\",\"auth\":true}"];
            
            NSLog(@"The bodyContainerString that will be ecoded is: %@", bodyContainerString2);
            
            //encript the body using the md5
            NSString *bodyContainerStringEncoded2 = [self md5:bodyContainerString2];
            NSLog(@"bha after md5 encripted %@",bodyContainerStringEncoded2);
            
            
            
            //            forging the Claims token of format
            //            {
            //                "api_id": "debugger",
            //                "exp": 1451606400,
            //                "bha": "c23543fd68fe6c8b82691ab2b402f423"
            //            }
            NSMutableString *claimsStringFromatter = [[NSMutableString alloc] init];
            [claimsStringFromatter appendString: @"{\"api_id\":\""];
            [claimsStringFromatter appendString:api_id];
            [claimsStringFromatter appendString: @"\",\""];
            [claimsStringFromatter appendString: @"exp\":"];
            [claimsStringFromatter appendString:[NSString stringWithFormat:@"%d",(int)expirationDateForPostMethod]];
            [claimsStringFromatter appendString: @",\"bha\":\""];
            [claimsStringFromatter appendString: bodyContainerStringEncoded2];
            [claimsStringFromatter appendString: @"\"}"];
            NSLog(@"The foremated claims string is: %@",claimsStringFromatter);
            
            //encode claims in 64 format
            NSData *claimsEncriptionDataUsed = [claimsStringFromatter dataUsingEncoding:NSUTF8StringEncoding];
            NSString *base64EncodedClaimsResult = [claimsEncriptionDataUsed base64EncodedStringWithOptions:nil];
            base64EncodedClaimsResult = [base64EncodedClaimsResult substringToIndex:[base64EncodedClaimsResult length]];
            NSLog(@"base64EncodedClaimsResult is: %@", base64EncodedClaimsResult);
            
            //test HMAC SHA256 for HMACSHA256(base64UrlEncode(header)+"."+base64UrlEncode(claims),"secret"
            NSString *signedPart = [NSString stringWithFormat:@"%@.%@",base64EncodedHeaderResult, base64EncodedClaimsResult];
            NSLog(@"Signed part before : %@", signedPart);
            
            //Convert from hmac sha256 to base 64
            
            //Retrive the message Key from NsUserDefaults
            //NSString* key = [[NSUserDefaults standardUserDefaults] stringForKey:kDebugger];
            
            NSString* key = [dictionaryWithContent objectForKey:@"apiKey"] ;
            NSLog(@"The secret key is: %@", key);
            
            const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
            const char *cData = [signedPart cStringUsingEncoding:NSASCIIStringEncoding];
            unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
            CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
            NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
            NSMutableString *hash = [[NSMutableString alloc]init];
            [hash appendString:[HMAC base64Encoding]];
            [hash setString:[hash substringToIndex:[hash length]-1]];
            hash =[hash stringByReplacingOccurrencesOfString:@"/" withString:@"^"];
            hash =[hash stringByReplacingOccurrencesOfString:@"-" withString:@"*"];
            hash =[hash stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            hash =[hash stringByReplacingOccurrencesOfString:@"*" withString:@"+"];
            hash =[hash stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
            hash =[hash stringByReplacingOccurrencesOfString:@"^" withString:@"_"];
            NSLog(hash);
            
            //The final TOKEN is:
            finalToken = [NSString stringWithFormat:@"%@.%@.%@",base64EncodedHeaderResult,base64EncodedClaimsResult, hash];
            NSURL *url = [NSURL URLWithString:@"http://sdk.chupamobile.com/api/smtgs"];
            
            
            //Create thhe session with custom configuration
            NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfiguration.HTTPAdditionalHeaders = @{
                                                           @"Authorization"       : [NSString stringWithFormat:@"BEARER %@",finalToken],
                                                           @"Content-Type"        : @"application/json"
                                                           };
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
            
            // 2
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            request.HTTPMethod = @"POST";
            
            // 3
            
            NSError *error = nil;
            
            NSData* jsonData = [bodyContainerString2 dataUsingEncoding:NSUTF8StringEncoding];
            
            
            if (!error) {
                // 4
                NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                           fromData:jsonData completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                               if (!error && (int)[httpResponse statusCode]==201) {
                                                                                   //if no error on upload then delete content of plist
                                                                                   NSLog(@"Success  on post so we empty the plist");
                                                                                   [[NSFileManager defaultManager] removeItemAtPath:self.pathForChupamobileHistoryPlist error:NULL];
                                                                                   
                                                                                   //reset counterForTheMethodPlistKey and empty the plist
                                                                                   [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"counterForTheMethodPlistKey"];
                                                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                   
                                                                               }
                                                                               
                                                                           }];
                
                // 5
                [uploadTask resume];
            } else {
                NSLog(@"ERROR: %@", [error localizedDescription]);
            }
        }
        else{
            
            NSLog(@"The stored array size is smaller than two");
        }
    }
    
    if (counterForMethodKey >15) {
        //reset the timer
        counterForMethodKey = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:counterForMethodKey forKey:@"counterForTimeTracker"];
        
    }
}

- (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
