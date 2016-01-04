/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
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

#import "AppDelegate.h"

// OneSDK
#import "OneSDK.h"
// Chartboost
#import <Chartboost/Chartboost.h>
#import <Chartboost/CBNewsfeed.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>
// Flurry Analytics
#import "Flurry.h"
// Nextpeer
//#import "Nextpeer/Nextpeer.h"
// iRate
#import "iRate.h"
// RevMob
#import <RevMobAds/RevMobAds.h>
// AppLovin
#import "ALSdk.h"

//---------------//
// TESTING SETUP //
//---------------//

// set your test devices IDs for testing AdMob
#define kAdMobFirstTestDeviceID @"ca-app-pub-5767684210972160/3857391532"
#define kAdMobSecondTestDeviceID @"ca-app-pub-5767684210972160/3857391532"

// set up your test IDs for rating
// give the IDs of an already existing app on the App Store
// uncomment the [[ChupamobileKit sharedKit] enableiRateTestModeWithTestAppID:kiRateTestAppID andTestAppBundleID:kiRateTestAppBundleID]; line at the Warning directive below to test the rating system
// make sure that after testing you comment those lines
// you must comment out that line before submitting to the App Store
static NSUInteger const kiRateTestAppID = 999999;
#define kiRateTestAppBundleID @"999999"

// add delegates
@interface AppDelegate () <ChartboostDelegate, CBNewsfeedDelegate> {//, NPTournamentDelegate> {//NextpeerDelegate> {
  NSTimer *timerForPostMethod;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  // determining first launch
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
  {
    // app already launched
  }
  else {
    
    // setting some defaults on first app launch that help Chupamobile Kit
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEnableDisableChupamobileKitLog]; // disabling Chupamobile Log by default
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kEnableDisableAdMobTestMode]; // disabling AdMob Test Mode by default
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAdsAreRemoved]; // setting the AdsAreRemoved flag to NO
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPlacementCountChartboostMainMenu]; // set this to 0 to show ad at first startup
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPlacementCountChartboostGameOver]; // set this to 0 to show ad at first gameplay
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPlacementCountAdMobMainMenu]; // set this to 0 to show ad at first main menu
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPlacementCountAdMobGameplay]; // set this to 0 to show ad at first gameplay
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kPlacementCountAdMobGameOver]; // set this to 0 to show ad at first game over
    
    [[NSUserDefaults standardUserDefaults] setObject:@"ca-app-pub-5767684210972160/3857391532" forKey:kAdMobTestIDForFirstDevice]; // setting up NSUserdefaults for first test device AdMob ID
    [[NSUserDefaults standardUserDefaults] setObject:@"ca-app-pub-5767684210972160/3857391532" forKey:kAdMobTestIDForSecondDevice]; // setting up NSUserdefaults for second test device AdMob ID
    
    // setting the ad counts
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountChartboostMainMenu];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountChartboostGameOver];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountAdMobMainMenu];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountAdMobGameplay];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountAdMobGameOver];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountRevMobMainMenu];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountRevMobGameOver];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountAppLovinMainMenu];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAdCountAppLovinGameOver];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // This is the first launch ever
    
  }
  
  // notification observer for multiplayer Nextpeer game launch
  [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startMultiPlayerGame:) name: NOTIFICATION_START_MULTIPLAYER object: nil];
  
  // starting OneSDK setup
  [self setupOneSDK];
  
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  //[self startRecordigHistory];
}

- (void) setupOneSDK {
  
  // start OneSDK
  [[OneSDK sharedSDK] startChupamobileKit];
  
  // enabling Chupamobile Log; should be set to NO on release
  [[OneSDK sharedSDK] enableChupamobileKitLog:YES];
#pragma message ("[Chupamobile Kit Warning] IMPORTANT: DISABLE ADMOB TEST MODE (SET TO `NO`) BEFORE SUBMITTING TO THE APP STORE")
  // disabling AdMob Test Mode; set this to YES to enable it
  [[OneSDK sharedSDK] enableAdMobTestMode:NO];
    
  // seting up AdMob Test IDs for devices; should be set up by reskinner
  // defines can be found at the top of this file
  // please enable AdMob Test Mode first
  [[OneSDK sharedSDK] setAdMobTestIDForFirstDevice:kAdMobFirstTestDeviceID];
  [[OneSDK sharedSDK] setAdMobTestIDForSecondDevice:kAdMobSecondTestDeviceID];
  
#pragma message ("[Chupamobile Kit Warning] IMPORTANT: COMMENT OUT BEFORE SUBMITTING TO THE APP STORE, MAKE THE LINE BE GREEN BY ADDING // AT THE BEGINNING OF IT")
  // comment out this before submission to the App Store
  // replace the AppID and BundleID with your own defined at the top of this file
  //[[ChupamobileKit sharedKit] enableiRateTestModeWithTestAppID:kiRateTestAppID andTestAppBundleID:kiRateTestAppBundleID];
  
  // checking if Chupamobile Kit log is enabled
  if ([[OneSDK sharedSDK] isChupamobileKitLogEnabled]) {
    cKLogEnabled = YES;
  } else {
    cKLogEnabled = NO;
  }
  
  // checking if ads are off or on
  if (![[OneSDK sharedSDK] areAdsRemoved]) {
    if (cKLogEnabled) {
      CKLog(@"Ads are ON.");
    }
    
    // checking if Chartboost is enabled
    if (CHARTBOOST_ENABLED) {
      if (cKLogEnabled) {
        CKLog(@"Chartboost is enabled.");
      }
      
      // checking if Chartboost IDs are set
      if ([CHARTBOOST_APP_ID  isEqual: kChupamobileChartboostAppID] || [CHARTBOOST_APP_SIGNATURE  isEqual: kChupamobileChartboostAppSignature]) {
        if (!AUTHOR_MODE) {
          UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                            message:@"\nYou want to use Chartboost but have not set up your Chartboost IDs. Please, set them up."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
          
          [message show];
        }
      } else {
        [self setupChartboost];
        
        if (cKLogEnabled) {
          CKLog(@"Chartboost IDs are set up. Starting Chartboost.");
        }
      }
      
    } else {
      if (cKLogEnabled) {
        CKLog(@"Chartboost is NOT enabled. Not Starting Chartboost.");
      }
    }
    
    // checking if RevMob is enabled
    if (REVMOB_ENABLED) {
      if (cKLogEnabled) {
        CKLog(@"RevMob is enabled.");
      }
      
      // checking if RevMob ID is set
      if ([REVMOB_MEDIA_ID  isEqual: kChupamobileRevMobMediaID]) {
        if (!AUTHOR_MODE) {
          UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                            message:@"\nYou want to use RevMob but have not set up your RevMob Media ID. Please, set it up."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
          
          [message show];
        }
      } else {
        [self setupRevMob];
        
        if (cKLogEnabled) {
          CKLog(@"RevMob Media ID is set up. Starting RevMob.");
        }
      }
      
    } else {
      if (cKLogEnabled) {
        CKLog(@"RevMob is NOT enabled. Not Starting RevMob.");
      }
    }
    
    // checking if AppLovin is enabled
    if (APPLOVIN_ENABLED) {
      if (cKLogEnabled) {
        CKLog(@"AppLovin is enabled.");
      }
      
      // checking if AppLovin Sdk Key is set
      
      if ([APPLOVIN_SDK_KEY  isEqual: kChupamobileAppLovinSdkKey]) {
        if (!AUTHOR_MODE) {
          UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                            message:@"\nYou want to use AppLovin but have not set up your AppLovin Sdk Key. Please, set it up in the Info.plist file."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Got it"
                                                  otherButtonTitles:nil];
          
          [message show];
        }
      } else {
        [self setupAppLovin];
        
        if (cKLogEnabled) {
          CKLog(@"AppLovin Sdk is set up. Starting AppLovin.");
        }
      }
      
    } else {
      if (cKLogEnabled) {
        CKLog(@"AppLovin is NOT enabled. Not Starting AppLovin.");
      }
    }
    
  } else {
    if (cKLogEnabled) {
      CKLog(@"Ads are OFF. Not Starting Ads.");
    }
  }
  
  // checking if Flurry is enabled
  if (FLURRY_ENABLED) {
    
    if (cKLogEnabled) {
      CKLog(@"Flurry is enabled.");
    }
    
    // checking if Flurry API Key is set
    if ([FLURRY_API_KEY isEqual:kChupamobileFlurryAPIKey]) {
      if (!AUTHOR_MODE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\nYou want to use Flurry but have not set up your Flurry API Key. Please, set it up."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
      }
    } else {
      [self setupFlurry];
      
      if (cKLogEnabled) {
        CKLog(@"Flurry API Key is set. Starting Flurry.");
      }
    }
    
  } else {
    if (cKLogEnabled) {
      CKLog(@"Flurry is NOT enabled. Not Starting Flurry.");
    }
  }
  
  // checking if Nextpeer is enabled
  if (NEXTPEER_ENABLED) {
    if (cKLogEnabled) {
      CKLog(@"Nextpeer is enabled.");
    }
    
    // checking if Nextpeer Game Key is set
    if ([NEXTPEER_GAME_KEY isEqual:kChupamobileNextpeerGameKey]) {
      if (!AUTHOR_MODE) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Chupamobile Kit"
                                                          message:@"\nYou want to use Nextpeer but have not set up your Nextpeer Game Key. Please, set it up."
                                                         delegate:nil
                                                cancelButtonTitle:@"Got it"
                                                otherButtonTitles:nil];
        
        [message show];
      }
    } else {
     // [self initializeNextpeer];
      
      if (cKLogEnabled) {
        CKLog(@"Nextpeer Game Key is set up. Starting Nextpeer.");
      }
    }
    
  } else {
    if (cKLogEnabled) {
      CKLog(@"Nextpeer is NOT enabled. Not Starting Nextpeer.");
    }
  }
  
}

- (void) setupChartboost {
  
  // Begin a user session.
  // Must not be dependent on user actions or any prior network requests.
  [Chartboost startWithAppId:CHARTBOOST_APP_ID appSignature:CHARTBOOST_APP_SIGNATURE delegate:self];
  
}

- (void) setupRevMob {
  [RevMobAds startSessionWithAppID:REVMOB_MEDIA_ID];
}

- (void) setupAppLovin {
  // initializing AppLovin with a key that is not in the Info.plist
  appLovinSdk = [ALSdk sharedWithKey: APPLOVIN_SDK_KEY];
  //[ALSdk initializeSdk];
}

- (void) setupFlurry {
  
  // crash reporting
  // note: iOS only allows one crash reporting tool per app; if using another, set to: NO
  [Flurry setCrashReportingEnabled:YES];
  
  // start the Flurry Analytics session
  [Flurry startSession:FLURRY_API_KEY];
}

/*- (void)initializeNextpeer {
  
  NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                            
                            // Support orientation change for the dashboard notifications
                            [NSNumber numberWithBool:YES], //NextpeerSettingSupportsDashboardRotation,
                            //  Place the in-game ranking display in the top-left of the screen and align it vertically, so as to not hide the scores.
                            [NSNumber numberWithInt:NPNotificationPosition_TOP_LEFT], NextpeerSettingNotificationPosition,
                            [NSNumber numberWithInt:NPRankingDisplayAlignmentHorizontal], NextpeerSettingRankingDisplayAlignment,
                            nil];
  
  
 // [Nextpeer initializeWithProductKey:NEXTPEER_GAME_KEY andSettings:settings andDelegates:
   [NPDelegatesContainer containerWithNextpeerDelegate:self tournamentDelegate:self]];
  
}*/

/*-(void)nextpeerDidTournamentStartWithDetails:(NPTournamentStartDataContainer *)tournamentContainer {
  // Add code that starts a tournament:
  // 1. Load scene
  // 2. Start game
  
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_START_MULTIPLAYER object:nil];
  
}*/


-(void)nextpeerDidTournamentEnd {
  // Add code that ends the current tournament
  // 1. Stop game and animations
  // 2. Release any unneeded resources
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
 /* if ([Nextpeer handleOpenURL:url]) {
    return YES;
  }*/
  
  // Handle other possible URLS
  
  return NO;
}

- (void) startMultiPlayerGame: (NSNotification *) notification
{
  if (cKLogEnabled) {
    CKLog(@"Nextpeer multiplayer game started. Showing Nextpeer panel.");
  }
  
#pragma message ("[Chupamobile Kit Warning] Nextpeer Setup: Please, add code to start gameplay. When done, you may safely ignore this message.")
  
  // TODO: Nextpeer Setup - Please, add code to start gameplay
  
  //CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
  //[[CCDirector sharedDirector] replaceScene:gameplayScene];
}

// recording activity
- (void) startRecordigHistory {
  
  
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"counterForTimeTracker"] != nil )
  {
    // app already launched
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"counterForTimeTracker"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // This is the first launch ever
  }
  
  
  self.myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(recordActivity) userInfo:nil
                                                repeats:YES];
  
  
}
- (void) recordActivity {
  NSLog(@"ENTER RECORD ACTIVITY");
  [[OneSDK sharedSDK] postHistoryOnServer];
}

@end
