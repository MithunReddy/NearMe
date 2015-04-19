//
//  MKPolygon+PointInPolygon.h
//  GeoFencePOC
//
//  Created by Panneerselvam, Rajkumar on 1/30/14.
//  Copyright (c) 2014 Panneerselvam, Rajkumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKPolygon (PointInPolygon)

-(BOOL)pointInPolygon:(CLLocationCoordinate2D)coord;
- (CLLocationCoordinate2D)centerCoordinateForPoints:(MKMapPoint *)points pointCount:(NSInteger)count;

@end
