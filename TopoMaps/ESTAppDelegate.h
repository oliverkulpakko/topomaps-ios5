//
//  ESTAppDelegate.h
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 East Studios Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESTMainViewController;

@interface ESTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ESTMainViewController *mainViewController;

@end
