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
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation ESTMainViewController
@synthesize mapView;
@synthesize locationButton;
@synthesize locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Location Manager
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    // Map Overlay
    
    TileOverlay *overlay = [[TileOverlay alloc] initWithUrlTemplate:@"https://tile.openstreetmap.org/{z}/{x}/{y}.png"];
    [mapView addOverlay:overlay];
    
    MKMapRect visibleRect = [mapView mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    mapView.visibleMapRect = visibleRect;
    
    [overlay release];
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
    [self setLocationButton:nil];
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

- (IBAction)showLocation:(id)sender {
    [mapView setRegion:MKCoordinateRegionMake(locationManager.location.coordinate, MKCoordinateSpanMake(0.05, 0.05)) animated:YES];
}

- (void)dealloc {
    [mapView release];
    [locationButton release];
    [super dealloc];
}
@end
