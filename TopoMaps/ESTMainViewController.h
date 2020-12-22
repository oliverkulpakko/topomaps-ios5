//
//  ESTMainViewController.h
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 __MyCompanyName__. All rights reserved.
//

#import "ESTFlipsideViewController.h"
#import <MapKit/MapKit.h>

@interface ESTMainViewController : UIViewController <ESTFlipsideViewControllerDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)showInfo:(id)sender;

@end
