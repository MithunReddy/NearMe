// Created by Barry Allard and your name here
//
// MIT license

#import "MKPolygon+Centroid.h"

//#import "MKPolygon+Area.h" // https://gist.github.com/steakknife/562c7d222d28d0fcb80d

@implementation MKPolygon (Centroid)
+ (MKMapPoint)centroidOfPoints:(MKMapPoint *)points count:(NSUInteger)count
{
    if (count < 3) {
        return MKMapPointMake(0, 0);
    }
    
    double areaTimesTwo = 0.0;
    double x = 0.0;
    double y = 0.0;
    
    MKMapPoint *previousPoint =  &(points[count - 1]);
    
    for (NSUInteger i = 0; i < count; ++i) {
        MKMapPoint *point = &(points[i]);
        
        const double delta = (previousPoint->x * point->y) - (point->x * previousPoint->y);
        
        x += (previousPoint->x + point->x) * delta;
        y += (previousPoint->y + point->y) * delta;
        
        areaTimesTwo += delta;
        
        previousPoint = point;
    }
    
    return MKMapPointMake(x / (3.0 * areaTimesTwo), y / (3.0 * areaTimesTwo));
}

//- (MKMapPoint)centroid
//{
//    
//    
//}

@end