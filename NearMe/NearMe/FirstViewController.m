//
//  FirstViewController.m
//  NearMe
//
//  Created by nunc03 on 4/3/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
{
    CLLocationManager *locationManager;
}
@end

@implementation FirstViewController
@synthesize drawingView,pointsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Hospitals";
    pointsArray = [[NSMutableArray alloc]init];
    latLang = [[NSMutableArray alloc]init];
    self.hospitalsMap.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];
    
    self.hospitalsMap.showsUserLocation = YES;
    [self.hospitalsMap setMapType:MKMapTypeStandard];
    [self.hospitalsMap setZoomEnabled:YES];
    [self.hospitalsMap setScrollEnabled:YES];
    [self addButtons];

}
-(void)addButtons{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    self.startDraw = [[UIButton alloc]initWithFrame:CGRectMake(width-50, 10, 40, 40)];
    [self.startDraw setBackgroundImage:[UIImage imageNamed:@"draw something.png"] forState:UIControlStateNormal];
    [self.startDraw addTarget:self action:@selector(startDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.hospitalsMap addSubview:self.startDraw];
    
    self.dtopDraw = [[UIButton alloc]initWithFrame:CGRectMake(width-50, 10, 40, 40)];
    [self.dtopDraw setBackgroundColor:[UIColor redColor]];
    [self.dtopDraw setTintColor:[UIColor whiteColor]];
    [self.dtopDraw setTitle:@"X" forState:UIControlStateNormal];
    [self.dtopDraw addTarget:self action:@selector(clearMap) forControlEvents:UIControlEventTouchUpInside];
    self.dtopDraw.titleLabel.font = [UIFont boldSystemFontOfSize: 40];
    [self.hospitalsMap addSubview:self.dtopDraw];
    
    self.dtopDraw.hidden = YES;
}
-(void)clearMap{
   // remove overlays
    self.dtopDraw.hidden = YES;
    self.startDraw.hidden = NO;
    [self.hospitalsMap removeOverlays:self.hospitalsMap.overlays];

}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];


    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.hospitalsMap setRegion:region animated:YES];
    
}
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
//    [self.hospitalsMap setRegion:[self.hospitalsMap regionThatFits:region] animated:YES];
//}
//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (IBAction)startDraw:(id)sender {
    self.hospitalsMap.userInteractionEnabled = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    drawImage.image = [defaults objectForKey:@"drawImageKey"];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = CGRectMake(0, 0, self.hospitalsMap.frame.size.width, self.hospitalsMap.frame.size.height);
    [self.hospitalsMap addSubview:drawImage];
    drawImage.backgroundColor = [UIColor clearColor];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([touch tapCount] == 2) {
        
        drawImage.image = nil;
        
    }
    
    location = [touch locationInView:self.hospitalsMap];
    
    lastClick = [NSDate date];
    
    lastPoint = [touch locationInView:self.hospitalsMap];
    
    lastPoint.y -= 0;
    
    mouseSwiped = YES;
    
    [super touchesBegan: touches withEvent: event];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    NSLog(@"stop ****************************");
    [self stopDraw:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self.hospitalsMap];
    UIGraphicsBeginImageContext(CGSizeMake(self.hospitalsMap.frame.size.width, self.hospitalsMap.frame.size.height));
    [drawImage.image drawInRect:CGRectMake(0, 0, self.hospitalsMap.frame.size.width, self.hospitalsMap.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 0, 0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    [drawImage setFrame:CGRectMake(0, 0, self.hospitalsMap.frame.size.width, self.hospitalsMap.frame.size.height)];
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (mouseSwiped) {
        //Code for saving the data in backgroundxr
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Add code here to do background processing
            CLLocationCoordinate2D centerOfMapCoord = [self.hospitalsMap convertPoint:currentPoint toCoordinateFromView:self.hospitalsMap]; //Step 2
            CLLocation *towerLocation = [[CLLocation alloc] initWithLatitude:centerOfMapCoord.latitude longitude:centerOfMapCoord.longitude];
           // NSLog(@"%@",towerLocation);

            [latLang addObject:towerLocation];
           // NSLog(@"latLang:%@",latLang);

            dispatch_async( dispatch_get_main_queue(), ^{
                // Add code here to update the UI/send notifications based on the
                // results of the background processing
            });
        });
    }
    lastPoint = currentPoint;
    
}
- (IBAction)stopDraw:(id)sender {
    [drawingView removeFromSuperview];
    [drawImage removeFromSuperview];
    self.dtopDraw.hidden = NO;
    self.startDraw.hidden = YES;

    self.hospitalsMap.userInteractionEnabled = YES;
    NSLog(@"latLang:%@",latLang);

    CLLocationCoordinate2D *coords =
    
    malloc(sizeof(CLLocationCoordinate2D) * [latLang count]);
    
    for(int idx = 0; idx < [latLang count]; idx++) {
        
        CLLocation* locationCL = [latLang objectAtIndex:idx];
        
        coords[idx] = CLLocationCoordinate2DMake(locationCL.coordinate.latitude,locationCL.coordinate.longitude);
        
    }
    
    polygon = [MKPolygon polygonWithCoordinates:coords count:[latLang count]];
    
    free(coords);
    [latLang removeAllObjects];
    [self.hospitalsMap addOverlay:polygon];
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay

{
    
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    polygonView.lineWidth = 5;
    polygonView.strokeColor = [UIColor blackColor];
    polygonView.fillColor = [UIColor clearColor];
    mapView.userInteractionEnabled = YES;
    
    return polygonView;
    
}
@end
