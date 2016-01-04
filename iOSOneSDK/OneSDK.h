//
//  ChupamobileKit.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CKDefaults.h"

#import "GADBannerView.h"

//#import "ALAdView.h"
//#import "ALAdLoadDelegate.h"

@interface OneSDK : NSObject /*<ALAdLoadDelegate>*/ {
    GADBannerView *bannerView_;
    
    NSString *adLocationName;
    NSString *adMobAdUnitID;
    
    AdMobBannerType adMobBannerType;
    float adMobBannerPosition_x, adMobBannerPosition_y;
    
    GADAdSize bannerSize;
    CGSize theViewSize;
}

#pragma mark Singleton
/**
 *  Creates and returns an `ChupamobileKit` singleton object.
 *
 *  @return ChupamobileKit singleton object.
 */
+ (id)sharedSDK;

#pragma mark Start Chupamobile Kit
/**
 *  Start Chupamobile Kit.
 */
- (void) startChupamobileKit;

#pragma mark Chupamobile Log
/**
 *  Enable (YES) or disable (NO) Chupamobile Kit Logging.
 *
 *  @param condition Enabled/disabled Log.
 */
- (void) enableChupamobileKitLog: (BOOL) condition;

/**
 *  Check if Chupamobile Kit Logging is enabled.
 *
 *  @return Chupamobile Kit Logging Enabled/Disabled.
 */
- (BOOL) isChupamobileKitLogEnabled;

#pragma mark Show Ad
/**
 *  Showing an ad.
 *
 *  @param cKAdLocation   One of the predefined locations to show the ad at.
 *  @param viewController The viewcontroller in where the ad is shown.
 *
 *  @discussion The `viewControler` is `[[UIApplication sharedApplication] keyWindow].rootViewController]` for Cocos2d games and `self` for non-Cocos2d apps.
 */
- (void) showAdAt:(CKAdLocation) cKAdLocation forViewController: (UIViewController*) viewController;

/**
 *  Hide banner
 */

- (void) hideBanner;

#pragma mark Remove Ads
/**
 *  Flag for Chupamobile Kit to remove ads. Fire this when your user has bought the `No Ads` IAP.
 */

- (void) removeAds;

/**
 *  Find out if ads are removed or not.
 *
 *  @return Ads removed or not.
 */
- (BOOL) areAdsRemoved;

#pragma mark AdMob
/**
 *  Enable (YES) or disable (NO) AdMob Test Mode.
 *
 *  @param condition Enable/disable AdMob Test Mode.
 */
- (void) enableAdMobTestMode:(BOOL) condition;

/**
 *  Check if AdMob Test Mode is enabled or disabled.
 *
 *  @return AdMob Test Mode Enabled/disabled.
 */
- (BOOL) isAdMobTestModeEnabled;

/**
 *  Set your first AdMob Test Device ID. Find it in the Log once you run your app on your device.
 *
 *  @param adMobTestDeviceID Your first test device AdMob Test ID.
 */
- (void) setAdMobTestIDForFirstDevice:(NSString*) adMobTestDeviceID;

/**
 *  AdMob First Test Device ID.
 *
 *  @return AdMob First Test Device ID.
 */
- (NSString*) adMobTestIDForFirstDevice;

/**
 *  Set your second AdMob Test Device ID. Find it in the Log once you run your app on your device.
 *
 *  @param adMobTestDeviceID Your second test device AdMob Test ID.
 */
- (void) setAdMobTestIDForSecondDevice:(NSString*) adMobTestDeviceID;

/**
 *  AdMob Second Test Device ID.
 *
 *  @return AdMob Second Test Device ID.
 */
- (NSString*) adMobTestIDForSecondDevice;

#pragma mark Chartboost
/**
 *  Show the More Apps Page (powered by Chartboost)
 */
- (void) showChartboostMoreApps;

#pragma mark Flurry
/**
 *  Log a Flurry Event with a name of your choice.
 *
 *  @param eventName The name of the event that will be logged in the Flurry Analytics Dashboard.
 *
 *  @discussion Don't forget to sign up for a free Flurry account.
 */
- (void) logFlurryEventWithName:(NSString*) eventName;

#pragma mark Nextpeer
/**
 *  Start a Nextpeer multiplayer game.
 *
 */
- (void) startNextpeerMultiplayerGame;

/**
 *  Report a Nextpeer multiplayer score.
 *
 *  @param currentScore The current score to be reported.
 */
- (void) reportNextpeerScore:(uint32_t) currentScore;

/**
 *  End the Nextpeer multiplayer tournament and repert the current score.
 *
 *  @param currentScore The current score to be reported.
 */
- (void) endNextpeerMultiplayerGameAndReportScore:(uint32_t) currentScore;

#pragma mark iRate
/**
 *  Enable Testing iRate by providing the app ID and the bundle app ID of an app that already is on the App Store.
 *
 *  @param testAppID       The app ID of the test app.
 *  @param testAppBundleID The bundle app ID od the test app.
 */
- (void) enableiRateTestModeWithTestAppID: (NSInteger) testAppID andTestAppBundleID: (NSString*) testAppBundleID;

/**
 *  Go to the App Store page of the app and eventually rate it.
 */
- (void) rateApp;

- (void) writeToFileTheMethodThatWasCalled: (NSString *) nameOfTheMethod;

- (void) postHistoryOnServer;

@property (strong, nonatomic) NSString *pathForChupamobileHistoryPlist;


@end
