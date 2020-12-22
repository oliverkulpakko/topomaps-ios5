//
//  ESTMainViewController.m
//  TopoMaps
//
//  Created by Oliver Kulpakko on 12/22/20.
//  Copyright (c) 2020 East Studios Oy. All rights reserved.
//

#import "ESTMainViewController.h"

@interface ESTMainViewController ()

@end

@implementation ESTMainViewController
@synthesize mapView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
