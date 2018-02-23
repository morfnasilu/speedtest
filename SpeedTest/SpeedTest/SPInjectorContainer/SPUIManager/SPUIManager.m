//
//  SPUIManager.m
//  SpeedTest
//
//  Created by Dmtech on 19.02.18.
//  Copyright © 2018 Dmtech. All rights reserved.
//

#import "SPUIManager.h"
#import "SPSettingsViewController.h"
#import "SPSpeedViewController.h"
#import "SPFTPViewController.h"

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
    SPSpeedViewController *speedViewController = [[SPSpeedViewController alloc] init];
    speedViewController.tabBarItem.title = NSLocalizedString(@"Test speed", @"Test speed");
    
    SPFTPViewController *ftpViewController = [[SPFTPViewController alloc] init];
    ftpViewController.tabBarItem.title = NSLocalizedString(@"FTP test speed", @"FTP test speed");
    
    SPSettingsViewController *settingsViewController = [[SPSettingsViewController alloc] init];
    settingsViewController.tabBarItem.title = NSLocalizedString(@"Settings", @"Settings");
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[speedViewController, ftpViewController, settingsViewController];
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    window.rootViewController = _tabBarController;
}

@end

