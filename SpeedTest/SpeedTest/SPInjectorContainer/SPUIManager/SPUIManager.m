//
//  SPUIManager.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPUIManager.h"
#import "SPSettingsViewController.h"
#import "SPFTPViewController.h"
#import "SPThroughputTestViewController.h"
#import "SPSpeedTestHistoryViewConroller.h"

@interface SPUIManager() {
    UITabBarController *_tabBarController;
}

@property (nonatomic, strong) id<SPUIManagerInjection>injection;

@end


@implementation SPUIManager

- (instancetype)initWithInjection:(id<SPUIManagerInjection>)injection {
    if (self = [super init]) {
        self.injection = injection;
    }
    return self;
}


-(void)commonInit {
    SPThroughputTestViewController *speedViewController = [[SPThroughputTestViewController alloc] init];
    speedViewController.tabBarItem.title = NSLocalizedString(@"Test speed", @"Test speed");
    
    SPFTPViewController *ftpViewController = [[SPFTPViewController alloc] init];
    ftpViewController.tabBarItem.title = NSLocalizedString(@"FTP test speed", @"FTP test speed");
    
    SPSettingsViewController *settingsViewController = [[SPSettingsViewController alloc] init];
    settingsViewController.tabBarItem.title = NSLocalizedString(@"Settings", @"Settings");
    
    SPSpeedTestHistoryViewConroller *historyViewController = [[SPSpeedTestHistoryViewConroller alloc] init];
    historyViewController.tabBarItem.title = NSLocalizedString(@"History", @"History");
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[speedViewController, ftpViewController, historyViewController, settingsViewController];
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    window.rootViewController = _tabBarController;
}

@end

