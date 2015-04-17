//
//  FirstViewController.h
//  NearMe
//
//  Created by nunc03 on 4/3/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface FirstViewController : UIViewController<CLLocationManagerDelegate>
{
    UIImageView *drawImage;
    CGPoint location;
    
    NSDate *lastClick;
    
    BOOL mouseSwiped;
    
    CGPoint lastPoint;
    
    CGPoint currentPoint;
    
    NSMutableArray *latLang;
    
    MKPolygon *polygon;
}
@property (weak, nonatomic) IBOutlet MKMapView *hospitalsMap;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *startDraw;
- (IBAction)startDraw:(id)sender;
@property(nonatomic,strong)UIView *drawingView;
- (IBAction)stopDraw:(id)sender;

@end

