//
//  CKDefaults.h
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

#import "ALSdk.h"

#ifndef ChupamobileKit_Defaults_h
#define ChupamobileKit_Defaults_h

    ///////////////////////////////////
    // PLEASE DO NOT TOUCH THESE !!! //
    ///////////////////////////////////

ALSdk* appLovinSdk;

BOOL cKLogEnabled;
BOOL cKTutorialLogEnabled;

/*
typedef NS_ENUM(NSInteger, CKAdLocation) {
    CKAdLocationMainMenu,
    CKAdLocationGameplay,
    CKAdLocationGameOver
};*/

typedef enum {
    CKAdLocationMainMenu,
    CKAdLocationGameplay,
    CKAdLocationGameOver
} CKAdLocation;

typedef NS_ENUM(NSInteger, AdMobBannerType) {
    kAdMobBannerPortraitTop,
    kAdmobBannerPortraitBottom,
    kAdMobBannerLandscapeTop,
    kAdMobBannerLandscapeBottom
};

#define isOrientationPortrait [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

#define IS_WIDESCREEN_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( IS_IPHONE && IS_WIDESCREEN_6 )

#define IS_WIDESCREEN_6_PLUS ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS ( IS_IPHONE && IS_WIDESCREEN_6_PLUS )

#define CKLog(fmt, ...) NSLog((@"[Chupamobile Kit Log] %s [Line %d] -- " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define kEnableDisableChupamobileKitLog @"EnableDisableChupamobileKitLog"
#define kEnableDisableAdMobTestMode @"EnableDisableAdMobTestMode"
#define kAdsAreRemoved @"AdsAreRemoved"

#define kPlacementCountChartboostMainMenu @"PlacementCountChartboostMainMenu"
#define kPlacementCountChartboostGameOver @"PlacementCountChartboostGameOver"
#define kPlacementCountAdMobMainMenu @"PlacementCountAdMobMainMenu"
#define kPlacementCountAdMobGameplay @"PlacementCountAdMobGameplay"
#define kPlacementCountAdMobGameOver @"PlacementCountAdMobGameOver"
#define kPlacementCountRevMobMainMenu @"PlacementCountRevMobMainMenu"
#define kPlacementCountRevMobGameOver @"PlacementCountRevMobGameOver"
#define kPlacementCountAppLovinMainMenu @"PlacementCountAppLovinMainMenu"
#define kPlacementCountAppLovinGameOver @"PlacementCountAppLovinGameOver"

#define kAdMobTestIDForFirstDevice @"AdMobTestIDForFirstDevice"
#define kAdMobTestIDForSecondDevice @"AdMobTestIDForSecondDevice"

#define kAdCountChartboostMainMenu @"AdCountChartboostMainMenu"
#define kAdCountChartboostGameOver @"AdCountChartboostGameOver"
#define kAdCountAdMobMainMenu @"AdCountAdMobMainMenu"
#define kAdCountAdMobGameplay @"AdCountAdMobGameplay"
#define kAdCountAdMobGameOver @"AdCountAdMobGameOver"
#define kAdCountRevMobMainMenu @"AdCountRevMobMainMenu"
#define kAdCountRevMobGameOver @"AdCountRevMobGameOver"
#define kAdCountAppLovinMainMenu @"AdCountAppLovinMainMenu"
#define kAdCountAppLovinGameOver @"AdCountAppLovinGameOver"

#define NOTIFICATION_START_MULTIPLAYER @"StartMultiPlayerGame"

NSString *settingsName;
NSString *settingsNamePlist;
NSMutableArray *settingsArray;

#define settingsName @"ChupamobileKitSettings"
#define settingsNamePlist @"ChupamobileKitSettings.plist"

#define kXLink @"XLink"
#define kXLinkPleaseDoNotEverChangeMeString @"PLEASE_DO_NOT_EVER_CHANGE_ME"

#define kCheckboxYes @"YES"
#define kCheckboxNo @"NO"

#define kApiID @"apiID"
#define kApiKey @"apiKey"

#define kAuthorMode @"Author Mode"

#define kChartboostEnabled @"Chartboost Enabled"
#define kChartboostAppID @"Chartboost App ID"
#define kChartboostAppSignature @"Chartboost App Signature"
#define kChartboostShowAdAtMainMenu @"Chartboost Show Ad At Main Menu"
#define kChartboostShowAdAtGameOver @"Chartboost Show Ad At Game Over"

#define kAdMobEnabled @"AdMob Enabled"
#define kAdMobBannerMainMenuID @"AdMob Banner Main Menu ID"
#define kAdMobBannerGameplayID @"AdMob Banner Gameplay ID"
#define kAdMobBannerGameOverID @"AdMob Banner Game Over ID"
#define kAdMobShowAdAtMainMenu @"AdMob Show Ad At Main Menu"
#define kAdMobShowAdAtGameplay @"AdMob Show Ad At Gameplay"
#define kAdMobShowAdAtGameOver @"AdMob Show Ad At Game Over"
#define kAdMobBannerMainMenuIsAtBottom @"AdMob Banner Main Menu Is At Bottom"
#define kAdMobBannerGameplayIsAtBottom @"AdMob Banner Gameplay Is At Bottom"
#define kAdMobBannerGameOverIsAtBottom @"AdMob Banner Game Over Is At Bottom"

#define kFlurryEnabled @"Flurry Enabled"
#define kFlurryAPIKey @"Flurry API Key"

#define kAdsFrequencyChartboostMainMenu @"Ads Frequency Chartboost Main Menu"
#define kAdsFrequencyChartboostGameOver @"Ads Frequency Chartboost Game Over"
#define kAdsFrequencyAdMobMainMenu @"Ads Frequency AdMob Main Menu"
#define kAdsFrequencyAdMobGameplay @"Ads Frequency AdMob Gameplay"
#define kAdsFrequencyAdMobGameOver @"Ads Frequency AdMob Game Over"
#define kAdsFrequencyRevMobMainMenu @"Ads Frequency RevMob Main Menu"
#define kAdsFrequencyRevMobGameOver @"Ads Frequency RevMob Game Over"
#define kAdsFrequencyAppLovinMainMenu @"Ads Frequency AppLovin Main Menu"
#define kAdsFrequencyAppLovinGameOver @"Ads Frequency AppLovin Game Over"

#define kNextpeerEnabled @"Nextpeer Enabled"
#define kNextpeerGameKey @"Nextpeer Game Key"

#define kiRateEnabled @"iRate Enabled"
#define kiRateDaysUntilPrompt @"iRate Days Until Prompt"
#define kiRateUsesUntilPrompt @"iRate Uses Until Prompt"
#define kiRateRemindPeriod @"iRate Remind Period"
#define kiRatePromptTitle @"iRate Prompt Title"
#define kiRatePromptMessage @"iRate Prompt Message"

#define kRevMobEnabled @"RevMob Enabled"
#define kRevMobMediaID @"RevMob Media ID"
#define kRevMobShowBannerAdAtMainMenu @"RevMob Show Banner Ad At Main Menu"
#define kRevMobShowInterstitialAdAtMainMenu @"RevMob Show Interstitial Ad At Main Menu"
#define kRevMobShowPopupAdAtMainMenu @"RevMob Show Popup Ad At Main Menu"
#define kRevMobShowInterstitialAdAtGameOver @"RevMob Show Interstitial Ad At Game Over"
#define kRevMobShowPopupAdAtGameOver @"RevMob Show Popup Ad At Game Over"
#define kAppLovinEnabled @"AppLovin Enabled"
#define kAppLovinSdkKey @"AppLovinSdkKey"
#define kAppLovinShowAdAtMainMenu @"AppLovin Show Ad At Main Menu"
#define kAppLovinShowAdAtGameOver @"AppLovin Show Ad At Game Over"

NSString *API_ID;
NSString *API_KEY;

BOOL AUTHOR_MODE;

BOOL CHARTBOOST_ENABLED;
NSString *CHARTBOOST_APP_ID;
NSString *CHARTBOOST_APP_SIGNATURE;
BOOL SHOW_CHARTBOOST_INTERSTITIAL_AT_MAIN_MENU;
BOOL SHOW_CHARTBOOST_INTERSTITIAL_AT_GAME_OVER;

BOOL ADMOB_ENABLED;
NSString *ADMOD_BANNER_MAIN_MENU_ID;
NSString *ADMOD_BANNER_GAMEPLAY_ID;
NSString *ADMOD_BANNER_GAME_OVER_ID;
BOOL SHOW_ADMOB_BANNER_AT_MAIN_MENU;
BOOL SHOW_ADMOB_BANNER_AT_GAMEPLAY;
BOOL SHOW_ADMOB_BANNER_AT_GAME_OVER;
BOOL ADMOB_BANNER_MAIN_MENU_IS_AT_BOTTOM;
BOOL ADMOB_BANNER_GAMEPLAY_IS_AT_BOTTOM;
BOOL ADMOB_BANNER_GAME_OVER_IS_AT_BOTTOM;

BOOL FLURRY_ENABLED;
NSString *FLURRY_API_KEY;

NSInteger ADS_FREQUENCY_CHARTBOOST_MAIN_MENU;
NSInteger ADS_FREQUENCY_CHARTBOOST_GAME_OVER;
NSInteger ADS_FREQUENCY_ADMOB_MAIN_MENU;
NSInteger ADS_FREQUENCY_ADMOB_GAMEPLAY;
NSInteger ADS_FREQUENCY_ADMOB_GAME_OVER;
NSInteger ADS_FREQUENCY_REVMOB_MAIN_MENU;
NSInteger ADS_FREQUENCY_REVMOB_GAME_OVER;
NSInteger ADS_FREQUENCY_APPLOVIN_MAIN_MENU;
NSInteger ADS_FREQUENCY_APPLOVIN_GAME_OVER;

BOOL NEXTPEER_ENABLED;
NSString *NEXTPEER_GAME_KEY;

BOOL IRATE_ENABLED;
NSInteger IRATE_DAYS_UNTIL_PROMPT;
NSInteger IRATE_USES_UNTIL_PROMPT;
NSInteger IRATE_REMIND_PERIOD;
NSString *IRATE_PROMPT_TITLE;
NSString *IRATE_PROMPT_MESSAGE;

BOOL REVMOB_ENABLED;
NSString *REVMOB_MEDIA_ID;
BOOL SHOW_REVMOB_BANNER_AT_MAIN_MENU;
BOOL SHOW_REVMOB_INTERSTITIAL_AT_MAIN_MENU;
BOOL SHOW_REVMOB_POPUP_AT_MAIN_MENU;
BOOL SHOW_REVMOB_INTERSTITIAL_AT_GAME_OVER;
BOOL SHOW_REVMOB_POPUP_AT_GAME_OVER;

BOOL APPLOVIN_ENABLED;
NSString *APPLOVIN_SDK_KEY;
BOOL SHOW_APPLOVIN_INTERSTITIAL_AT_MAIN_MENU;
BOOL SHOW_APPLOVIN_INTERSTITIAL_AT_GAME_OVER;

#define kChupamobileChartboostAppID @"999999"
#define kChupamobileChartboostAppSignature @"999999"

static NSInteger const kChupamobileiRateTestAppID = 999999;
#define kChupamobileiRateTestAppBundleID @"999999"

BOOL ADMOB_TEST_MODE_ENABLED;

#define kChupamobileAdMobBannerID @"999999"

#define kChupamobileFlurryAPIKey @"999999"

#define kChupamobileNextpeerGameKey @"999999"

#define kChupamobileRevMobMediaID @"999999"

#define kChupamobileAppLovinSdkKey @"999999"

#endif
