//
//  FirstViewController.h
//  NearMe
//
//  Created by nunc03 on 4/3/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AsyncRequest.h"
#import "MKPolygon+PointInPolygon.h"
#import "MKPolygon+Centroid.h"
#import "AppDelegate.h"
#import "KMAnnotation.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAP_CONSTANT 111133.14198903814
#define METER_FOOT 3.28084*3.28084
@interface SecondViewController : UIViewController<CLLocationManagerDelegate>
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
@property (strong, nonatomic) IBOutlet UIButton *startDraw;
- (IBAction)startDraw:(id)sender;
@property(nonatomic,strong)UIView *drawingView;
- (IBAction)stopDraw:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *dtopDraw;
@property(nonatomic,strong)NSMutableArray *pointsArray;
@property (nonatomic, strong) NSArray *hospitals;
@property(assign)BOOL isDraw;


@end

