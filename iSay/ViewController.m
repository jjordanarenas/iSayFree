//
//  ViewController.m
//  iSay
//
//  Created by Jorge Jordán on 04/04/15.
//  Copyright (c) 2015 Jorge Jordán. All rights reserved.
//

#import "ViewController.h"
#import "OneSDK.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize iphoneView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[OneSDK sharedSDK] showAdAt:CKAdLocationMainMenu forViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
