//
//  ESTMainViewController.h
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 East Studios Oy. All rights reserved.
//

#import "ESTFlipsideViewController.h"
#import <MapKit/MapKit.h>

@interface ESTMainViewController : UIViewController <ESTFlipsideViewControllerDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *locationButton;


- (IBAction)showInfo:(id)sender;
- (IBAction)showLocation:(id)sender;

@end
