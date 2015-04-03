//
//  SecondViewController.h
//  NearMe
//
//  Created by nunc03 on 4/3/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SecondViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *pharmacyMap;
@property(nonatomic, retain) CLLocationManager *locationManager;

@end

