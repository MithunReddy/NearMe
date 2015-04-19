//
//  MKPolygon+PointInPolygon.m
//  GeoFencePOC
//
//  Created by Panneerselvam, Rajkumar on 1/30/14.
//  Copyright (c) 2014 Panneerselvam, Rajkumar. All rights reserved.
//

#import "MKPolygon+PointInPolygon.h"


#import "MKPolygon+PointInPolygon.h"

@implementation MKPolygon (PointInPolygon)

-(BOOL)pointInPolygon:(CLLocationCoordinate2D) point {
    MKMapPoint mapPoint = MKMapPointForCoordinate(point);
//    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:self];
    MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithPolygon:self];
    CGPoint polygonViewPoint = [polygonView pointForMapPoint:mapPoint];
    return CGPathContainsPoint(polygonView.path, NULL, polygonViewPoint, NO);
}
double Deg_to_Rad(double degrees) {
    return (M_PI / 180) * degrees;
}
double Rad_to_Deg(double radians) {
    return (180 / M_PI) * radians;
}
- (CLLocationCoordinate2D)centerCoordinateForPoints:(MKMapPoint *)points pointCount:(NSInteger)count {
    double x = 0;
    double y = 0;
    double z = 0;
    
    for (int i = 0; i < count; i++) {
        CLLocationCoordinate2D coordinate = MKCoordinateForMapPoint(points[i]);
        
        double lat = Deg_to_Rad(coordinate.latitude);
        double lon = Deg_to_Rad(coordinate.longitude);
        x += cos(lat) * cos(lon);
        y += cos(lat) * sin(lon);
        z += sin(lat);
    }
    
    x = x / (double)count;
    y = y / (double)count;
    z = z / (double)count;
    
    double resultLon = atan2(y, x);
    double resultHyp = sqrt(x * x + y * y);
    double resultLat = atan2(z, resultHyp);
    
    CLLocationCoordinate2D result = CLLocationCoordinate2DMake(Rad_to_Deg(resultLat), Rad_to_Deg(resultLon));
    return result;
}
@end
