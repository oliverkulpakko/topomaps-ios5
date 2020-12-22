//
//  ESTMainViewController.m
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 East Studios Oy. All rights reserved.
//

#import "ESTMainViewController.h"
#import "TileOverlay.h"
#import "TileOverlayView.h"

@interface ESTMainViewController ()

@end

@implementation ESTMainViewController
@synthesize mapView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TileOverlay *overlay = [[TileOverlay alloc] initWithUrlTemplate:@"https://tile.openstreetmap.org/{z}/{x}/{y}.png"];
    [mapView addOverlay:overlay];
    
    // zoom in by a factor of two from the rect that contains the bounds
    // because MapKit always backs up to get to an integral zoom level so
    // we need to go in one so that we don't end up backed out beyond the
    // range of the TileOverlay.
    MKMapRect visibleRect = [mapView mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    mapView.visibleMapRect = visibleRect;
    
    [overlay release]; // map is now keeping track of overlay
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:overlay];
    view.tileAlpha = 1;
    return [view autorelease];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(ESTFlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    ESTFlipsideViewController *controller = [[[ESTFlipsideViewController alloc] initWithNibName:@"ESTFlipsideViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (void)dealloc {
    [mapView release];
    [super dealloc];
}
@end
