//
//  ESTFlipsideViewController.h
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 East Studios Oy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ESTFlipsideViewController;

@protocol ESTFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(ESTFlipsideViewController *)controller;
@end

@interface ESTFlipsideViewController : UIViewController

@property (assign, nonatomic) id <ESTFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
