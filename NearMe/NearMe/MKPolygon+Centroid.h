// Created by Barry Allard and your name here
//
// MIT license

#import <MapKit/MapKit.h>

@interface MKPolygon (Centroid)
+ (MKMapPoint)centroidOfPoints:(MKMapPoint *)points count:(NSUInteger)count;
- (MKMapPoint)centroid;
@end