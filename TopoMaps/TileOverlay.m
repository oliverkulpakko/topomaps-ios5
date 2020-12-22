//     File: TileOverlay.m
// Abstract: 
//     MKOverlay model class representing a tiled raster map overlay described by a directory hierarchy of tile images.
//   
//  Version: 1.0
// 
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
// 
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
// 
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
// 
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 

#import "TileOverlay.h"

#define TILE_SIZE 256.0

@interface ImageTile (FileInternal)
- (id)initWithFrame:(MKMapRect)f url:(NSURL *)u;
@end

@implementation ImageTile

@synthesize frame, imageUrl;

- (id)initWithFrame:(MKMapRect)f url:(NSURL *)u
{
    if (self = [super init]) {
        imageUrl = [u retain];
        frame = f;
    }
    return self;
}

- (void)dealloc
{
    [imageUrl release];
    [super dealloc];
}

@end

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

@implementation TileOverlay

- (id)initWithUrlTemplate:(NSString *)u
{
    if (self = [super init]) {
        urlTemplate = [u retain];
        flippedY = NO;
        boundingMapRect = MKMapRectWorld;
        /*if (![urlTemplate con:@"{z}"] || ![urlTemplate contains:@"{x}"] ||[urlTemplate contains:@"{z}"]) {
            NSLog(@"Invalid url template %@", urlTemplate);
            [urlTemplate release];
            [self release];
            return nil;
        }*/
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(boundingMapRect),
                                                  MKMapRectGetMidY(boundingMapRect)));
}

- (MKMapRect)boundingMapRect
{
    return MKMapRectWorld;
}

- (void)dealloc
{
    [urlTemplate release];
    [super dealloc];
}

- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{
    NSInteger z = zoomScaleToZoomLevel(scale);
    
    // Number of tiles wide or high (but not wide * high)
    NSInteger tilesAtZ = pow(2, z);
    
    NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / TILE_SIZE);
    NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / TILE_SIZE);
    NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / TILE_SIZE);
    NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / TILE_SIZE);
    
    NSMutableArray *tiles = [[NSMutableArray alloc] init];
    
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            NSInteger tileY = flippedY ? abs(y + 1 - tilesAtZ) : y;
            if (flippedY) {
                y = abs(y + 1 - tilesAtZ);
            }
            
            MKMapRect frame = MKMapRectMake((double)(x * TILE_SIZE) / scale,
                                            (double)(y * TILE_SIZE) / scale,
                                            TILE_SIZE / scale,
                                            TILE_SIZE / scale);
            
            NSMutableDictionary *templateDict = [[NSMutableDictionary alloc] init];
            [templateDict setValue:[NSString stringWithFormat:@"%i", z] forKey:@"{z}"];
            [templateDict setValue:[NSString stringWithFormat:@"%i", x] forKey:@"{x}"];
            [templateDict setValue:[NSString stringWithFormat:@"%i", tileY] forKey:@"{y}"];
            
            NSURL *url = [[NSURL alloc] initWithString:[self stringByReplacingTemplates:templateDict inString:urlTemplate]];
            
            ImageTile *tile = [[ImageTile alloc] initWithFrame:frame url:url];
            [templateDict release];
            [tiles addObject:tile];
            [tile release];
        }
    }
    
    return tiles;
}

- (NSString *)stringByReplacingTemplates:(NSDictionary *)templates inString:(NSString *)string {
    NSString *mString = string;
    
    for (NSString *key in templates) {
        mString = [mString stringByReplacingOccurrencesOfString:key withString:[templates objectForKey:key]];
    }
    
    return mString;
}

@end
