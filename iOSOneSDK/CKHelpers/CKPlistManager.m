//
//  CKPlistManager.m
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

#import "CKPlistManager.h"
#import "CKDefaults.h"

@implementation CKPlistManager

+ (void) setupPlistValues {
    [self copyPlist];
    [self createArrayFromPlist];
    [self saveAllPlistDataToNSUserDefaults];
    [self setupPlistFileData];
}

+ (void) copyPlist {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory =  [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:settingsNamePlist];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //check if the file exists already in users documents folder
    //if file does not exist copy it from the application bundle Plist file
    /*
    if ( ![fileManager fileExistsAtPath:path] ) {
        NSLog(@"Copying %@ to users desktop.", settingsName);
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:settingsName ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&error];
    }
    //if file is already there do nothing
    else {
        NSLog(@"%@ already configured.", settingsName);
    }*/
    
    
    NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:settingsName ofType:@"plist"];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSLog(@"Removing %@ from users documents.", settingsName);
        [fileManager removeItemAtPath:path error:&error];
    }
    
    NSLog(@"Copying %@ to users documents.", settingsName);
    [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&error];

}

+ (void) createArrayFromPlist {
    //create array from Plist document of all settings
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory =  [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:settingsNamePlist];
    settingsArray = [[[NSMutableArray alloc] initWithContentsOfFile:plistPath]mutableCopy];
    
    NSLog(@"%@", settingsArray);

}

+ (NSString* ) readDataFromPlistWithKey: (NSString*) key {
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *object in settingsArray) {
        if ([[object objectForKey:kXLink] isEqualToString:kXLinkPleaseDoNotEverChangeMeString]) {
            [tempArray insertObject:object atIndex:0];
        }
    }
    
    NSMutableDictionary *dict = [tempArray objectAtIndex:0];
    
    NSString *value;
    value = [dict objectForKey:key];
    
    return value;
}

+ (void) savePlistDataToNSUserDefaultsWithKey: (NSString*) key {
    NSString *theValue = [self readDataFromPlistWithKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:theValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveAllPlistDataToNSUserDefaults {
  
  [self savePlistDataToNSUserDefaultsWithKey:kApiID];
  [self savePlistDataToNSUserDefaultsWithKey:kApiKey];
    
    [self savePlistDataToNSUserDefaultsWithKey:kAuthorMode];
    
    [self savePlistDataToNSUserDefaultsWithKey:kChartboostEnabled];
    [self savePlistDataToNSUserDefaultsWithKey:kChartboostAppID];
    [self savePlistDataToNSUserDefaultsWithKey:kChartboostAppSignature];
    [self savePlistDataToNSUserDefaultsWithKey:kChartboostShowAdAtMainMenu];
    [self savePlistDataToNSUserDefaultsWithKey:kChartboostShowAdAtGameOver];
    
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobEnabled];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerMainMenuID];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerGameplayID];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerGameOverID];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobShowAdAtMainMenu];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobShowAdAtGameplay];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobShowAdAtGameOver];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerMainMenuIsAtBottom];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerGameplayIsAtBottom];
    [self savePlistDataToNSUserDefaultsWithKey:kAdMobBannerGameOverIsAtBottom];
    
    [self savePlistDataToNSUserDefaultsWithKey:kFlurryEnabled];
    [self savePlistDataToNSUserDefaultsWithKey:kFlurryAPIKey];
    
    [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyChartboostMainMenu];
    [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyChartboostGameOver];
    [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyAdMobMainMenu];
    [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyAdMobGameplay];
    [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyAdMobGameOver];
  [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyRevMobMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyRevMobGameOver];
  [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyAppLovinMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kAdsFrequencyAppLovinGameOver];
  
    [self savePlistDataToNSUserDefaultsWithKey:kNextpeerEnabled];
    [self savePlistDataToNSUserDefaultsWithKey:kNextpeerGameKey];
    
    [self savePlistDataToNSUserDefaultsWithKey:kiRateEnabled];
    [self savePlistDataToNSUserDefaultsWithKey:kiRateDaysUntilPrompt];
    [self savePlistDataToNSUserDefaultsWithKey:kiRateUsesUntilPrompt];
    [self savePlistDataToNSUserDefaultsWithKey:kiRateRemindPeriod];
    [self savePlistDataToNSUserDefaultsWithKey:kiRatePromptTitle];
    [self savePlistDataToNSUserDefaultsWithKey:kiRatePromptMessage];
  
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobEnabled];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobMediaID];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobShowBannerAdAtMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobShowInterstitialAdAtMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobShowPopupAdAtMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobShowInterstitialAdAtGameOver];
  [self savePlistDataToNSUserDefaultsWithKey:kRevMobShowPopupAdAtGameOver];
  
  [self savePlistDataToNSUserDefaultsWithKey:kAppLovinEnabled];
  [self savePlistDataToNSUserDefaultsWithKey:kAppLovinSdkKey];
  [self savePlistDataToNSUserDefaultsWithKey:kAppLovinShowAdAtMainMenu];
  [self savePlistDataToNSUserDefaultsWithKey:kAppLovinShowAdAtGameOver];
    
}

+ (NSString*) getStringValueFromNSUserDefaultsWithKey: (NSString*) key {
    NSString *theValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return theValue;
}

+ (BOOL) getBoolValueFromNSUserDefaultsWithKey: (NSString*) key {
    NSString *theValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([theValue  isEqual: @"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger) getIntValueFromNSUserDefaultsWithKey: (NSString*) key {
    NSInteger theValue = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    return theValue;
}

+ (void) setupPlistFileData {
  
  API_ID = [self getStringValueFromNSUserDefaultsWithKey:kApiID];
  API_KEY = [self getStringValueFromNSUserDefaultsWithKey:kApiKey];
    
    AUTHOR_MODE = [self getBoolValueFromNSUserDefaultsWithKey:kAuthorMode];
    
    CHARTBOOST_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kChartboostEnabled];
    CHARTBOOST_APP_ID = [self getStringValueFromNSUserDefaultsWithKey:kChartboostAppID];
    CHARTBOOST_APP_SIGNATURE = [self getStringValueFromNSUserDefaultsWithKey:kChartboostAppSignature];
    SHOW_CHARTBOOST_INTERSTITIAL_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kChartboostShowAdAtMainMenu];
    SHOW_CHARTBOOST_INTERSTITIAL_AT_GAME_OVER = [self getBoolValueFromNSUserDefaultsWithKey:kChartboostShowAdAtGameOver];
    
    ADMOB_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobEnabled];
    ADMOD_BANNER_MAIN_MENU_ID = [self getStringValueFromNSUserDefaultsWithKey:kAdMobBannerMainMenuID];
    ADMOD_BANNER_GAMEPLAY_ID  =[self getStringValueFromNSUserDefaultsWithKey:kAdMobBannerGameplayID];
    ADMOD_BANNER_GAME_OVER_ID = [self getStringValueFromNSUserDefaultsWithKey:kAdMobBannerGameOverID];
    SHOW_ADMOB_BANNER_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobShowAdAtMainMenu];
    SHOW_ADMOB_BANNER_AT_GAMEPLAY = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobShowAdAtGameplay];
    SHOW_ADMOB_BANNER_AT_GAME_OVER = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobShowAdAtGameOver];
    ADMOB_BANNER_MAIN_MENU_IS_AT_BOTTOM = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobBannerMainMenuIsAtBottom];
    ADMOB_BANNER_GAMEPLAY_IS_AT_BOTTOM = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobBannerGameplayIsAtBottom];
    ADMOB_BANNER_GAME_OVER_IS_AT_BOTTOM = [self getBoolValueFromNSUserDefaultsWithKey:kAdMobBannerGameOverIsAtBottom];
    
    FLURRY_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kFlurryEnabled];
    FLURRY_API_KEY = [self getStringValueFromNSUserDefaultsWithKey:kFlurryAPIKey];
    
    ADS_FREQUENCY_CHARTBOOST_MAIN_MENU = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyChartboostMainMenu];
    ADS_FREQUENCY_CHARTBOOST_GAME_OVER = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyChartboostGameOver];
    ADS_FREQUENCY_ADMOB_MAIN_MENU = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyAdMobMainMenu];
    ADS_FREQUENCY_ADMOB_GAMEPLAY = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyAdMobGameplay];
    ADS_FREQUENCY_ADMOB_GAME_OVER = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyAdMobGameOver];
  ADS_FREQUENCY_REVMOB_MAIN_MENU = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyRevMobMainMenu];
  ADS_FREQUENCY_REVMOB_GAME_OVER = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyRevMobGameOver];
  ADS_FREQUENCY_APPLOVIN_MAIN_MENU = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyAppLovinMainMenu];
  ADS_FREQUENCY_APPLOVIN_GAME_OVER = [self getIntValueFromNSUserDefaultsWithKey:kAdsFrequencyAppLovinGameOver];
    
    NEXTPEER_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kNextpeerEnabled];
    NEXTPEER_GAME_KEY = [self getStringValueFromNSUserDefaultsWithKey:kNextpeerGameKey];
    
    IRATE_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kiRateEnabled];
    IRATE_DAYS_UNTIL_PROMPT = [self getIntValueFromNSUserDefaultsWithKey:kiRateDaysUntilPrompt];
    IRATE_USES_UNTIL_PROMPT = [self getIntValueFromNSUserDefaultsWithKey:kiRateUsesUntilPrompt];
    IRATE_REMIND_PERIOD = [self getIntValueFromNSUserDefaultsWithKey:kiRateRemindPeriod];
    IRATE_PROMPT_TITLE = [self getStringValueFromNSUserDefaultsWithKey:kiRatePromptTitle];
    IRATE_PROMPT_MESSAGE = [self getStringValueFromNSUserDefaultsWithKey:kiRatePromptMessage];
  
  REVMOB_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobEnabled];
  REVMOB_MEDIA_ID = [self getStringValueFromNSUserDefaultsWithKey:kRevMobMediaID];
  SHOW_REVMOB_BANNER_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobShowBannerAdAtMainMenu];
  SHOW_REVMOB_INTERSTITIAL_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobShowInterstitialAdAtMainMenu];
  SHOW_REVMOB_POPUP_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobShowPopupAdAtMainMenu];
  SHOW_REVMOB_INTERSTITIAL_AT_GAME_OVER = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobShowInterstitialAdAtGameOver];
  SHOW_REVMOB_POPUP_AT_GAME_OVER = [self getBoolValueFromNSUserDefaultsWithKey:kRevMobShowPopupAdAtGameOver];
  
  APPLOVIN_ENABLED = [self getBoolValueFromNSUserDefaultsWithKey:kAppLovinEnabled];
  //APPLOVIN_SDK_KEY = [[NSBundle mainBundle].infoDictionary objectForKey:@"AppLovinSdkKey"];
  APPLOVIN_SDK_KEY = [self getStringValueFromNSUserDefaultsWithKey:kAppLovinSdkKey];
  SHOW_APPLOVIN_INTERSTITIAL_AT_MAIN_MENU = [self getBoolValueFromNSUserDefaultsWithKey:kAppLovinShowAdAtMainMenu];
  SHOW_APPLOVIN_INTERSTITIAL_AT_GAME_OVER = [self getBoolValueFromNSUserDefaultsWithKey:kAppLovinShowAdAtGameOver];
    
}

@end
