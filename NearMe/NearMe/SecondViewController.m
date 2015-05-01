//
//  SecondViewController.m
//  NearMe
//
//  Created by nunc03 on 4/3/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import "SecondViewController.h"
#import "MBProgressHUD.h"
@interface SecondViewController ()
{
    CLLocationManager *locationManager;
    MBProgressHUD *HUD;
}
@end

@implementation SecondViewController
@synthesize drawingView,pointsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    //76 135 224
    // iOS 7.0 or later
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:76.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"Pharmacy";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:76.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:76.0/255.0 green:135.0/255.0 blue:224.0/255.0 alpha:1.0]];
    
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
    
    self.startDraw = [[UIButton alloc]initWithFrame:CGRectMake(width-90, 10, 80, 80)];
    [self.startDraw setBackgroundImage:[UIImage imageNamed:@"draw.png"] forState:UIControlStateNormal];
    [self.startDraw addTarget:self action:@selector(startDraw:) forControlEvents:UIControlEventTouchUpInside];
    [self.hospitalsMap addSubview:self.startDraw];
    
    self.dtopDraw = [[UIButton alloc]initWithFrame:CGRectMake(width-90, 10, 80, 80)];
    [self.dtopDraw setTintColor:[UIColor whiteColor]];
    [self.dtopDraw setBackgroundImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
    [self.dtopDraw addTarget:self action:@selector(clearMap) forControlEvents:UIControlEventTouchUpInside];
    self.dtopDraw.titleLabel.font = [UIFont boldSystemFontOfSize:40];
    [self.hospitalsMap addSubview:self.dtopDraw];
    
    self.dtopDraw.hidden = YES;
}
-(void)clearMap{
    // remove overlays
    self.dtopDraw.hidden = YES;
    self.startDraw.hidden = NO;
    [self.hospitalsMap removeOverlays:self.hospitalsMap.overlays];
    [self removeAllPinsButUserLocation];
    
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
    self.isDraw = YES;
    self.hospitalsMap.userInteractionEnabled = NO;
    [latLang removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    drawImage.image = [defaults objectForKey:@"drawImageKey"];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = CGRectMake(0, 0, self.hospitalsMap.frame.size.width, self.hospitalsMap.frame.size.height);
    [self.hospitalsMap addSubview:drawImage];
    latLang = [[NSMutableArray alloc]init];
    drawImage.backgroundColor = [UIColor clearColor];
    //    polygon = nil;
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
    if (self.isDraw) {
        self.isDraw = NO;
        NSLog(@"stop ****************************");
        [self stopDraw:self];
    }
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
    [self sendRequest];
    self.dtopDraw.hidden = NO;
    self.startDraw.hidden = YES;
    
    self.hospitalsMap.userInteractionEnabled = YES;
    // NSLog(@"latLang:%@",latLang);
    
    CLLocationCoordinate2D *coords =
    
    malloc(sizeof(CLLocationCoordinate2D) * [latLang count]);
    
    for(int idx = 0; idx < [latLang count]; idx++) {
        
        CLLocation* locationCL = [latLang objectAtIndex:idx];
        
        coords[idx] = CLLocationCoordinate2DMake(locationCL.coordinate.latitude,locationCL.coordinate.longitude);
        
    }
    
    polygon = [MKPolygon polygonWithCoordinates:coords count:[latLang count]];
    
    free(coords);
    [self.hospitalsMap addOverlay:polygon];
    [latLang removeAllObjects];
    
    
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
-(void)sendRequest{
    double radius = [self calculateAreaforEffected:latLang];
    NSString *rad = [NSString stringWithFormat:@"%.0f",radius];
    if ([[NSString stringWithFormat:@"%.0f",radius] length] >6) {
        rad = [[NSString stringWithFormat:@"%.0f",radius]  substringToIndex:5];
    }
    CLLocation* locationCL = [latLang objectAtIndex:0];
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(locationCL.coordinate.latitude,locationCL.coordinate.longitude);
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%@&types=%@&key=AIzaSyA9xkXymeluJ8utaITKDw4GtOAy7nem28U",loc.latitude,loc.longitude,rad,PHARMACY_KEYWORD];
    NSLog(@"Url:%@",url);
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view.window addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD show:YES];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    AsyncRequest *request =
    [AsyncRequest requestWithURL:url
                          params:nil
                       onSuccess:^(NSData *data) {
                           /* use data */
                           // NSLog(@"%@",data);
                           [HUD hide:YES];
                           [self processHospitals:data];
                       } onErrror:^(NSError *error) {
                           /* manage error */
                           [HUD hide:YES];
                           NSLog(@"Error:%@",[error localizedDescription]);
                       }];
    [request setTimeoutInterval:80]; // seconds
    [request start];
}
-(double)calculateAreaforEffected:(NSMutableArray *)inCordinates{
    NSMutableArray *areaArray = [[NSMutableArray alloc]init];
    for (int m = 0; m < [inCordinates count]; ++m) {
        int n = (m+1)%[inCordinates count];
        CLLocation* locationCL = [latLang objectAtIndex:m];
        double xm = locationCL.coordinate.longitude*MAP_CONSTANT*cosf(locationCL.coordinate.latitude*M_PI/180.0);
        double ym = locationCL.coordinate.latitude*MAP_CONSTANT;
        CLLocation* locationCLn = [latLang objectAtIndex:n];
        double xn = locationCLn.coordinate.longitude*MAP_CONSTANT*cosf(locationCLn.coordinate.latitude*M_PI/180.0);
        double yn = locationCLn.coordinate.latitude*MAP_CONSTANT;
        double output = xm*yn-xn*ym;
        [areaArray addObject:[NSNumber numberWithDouble:output]];
    }
    double sum = 0;
    for (NSNumber *number in areaArray) {
        sum += [number doubleValue];
    }
    double metesr2 = ABS(sum/2.0);
    float areafeet2 = metesr2 *METER_FOOT;
    float areaMiles2 = areafeet2/5280.0/5280.0;
    float areaAcres = areaMiles2 * 640;
    return metesr2;
}
-(void)processHospitals:(NSData *)response {
    NSLog(@"Process Started");
    NSError *jsonParsingError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    NSLog(@"%@",dict);
    
    self.hospitals = [[NSArray alloc]init];
    if ( jsonParsingError == nil && dict ) {
        self.hospitals = [dict valueForKey:@"results"];
        NSLog(@"*********%@",self.hospitals);
        [self addAnnotation:self.hospitals];
    }
}
-(void)addAnnotation:(NSArray *)hospArray{
    for (NSDictionary *dict in hospArray) {
        if ([polygon pointInPolygon:[self useLocationString:[dict valueForKeyPath:@"geometry.location.lat"] andLong:[dict valueForKeyPath:@"geometry.location.lng"]]]) {
            KMAnnotation *point = [[KMAnnotation alloc] init];
            point.coordinate = [self useLocationString:[dict valueForKeyPath:@"geometry.location.lat"] andLong:[dict valueForKeyPath:@"geometry.location.lng"]];
            point.title = [dict valueForKey:@"name"];
            point.subtitle = [dict valueForKey:@"vicinity"];
            point.name = [dict valueForKey:@"name"];
            point.address = [dict valueForKey:@"vicinity"];
            point.dataDict = dict;
            [self.hospitalsMap addAnnotation:point];
        }
    }
    
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[KMAnnotation class]]) {
        KMAnnotation *knAnnot =(KMAnnotation *)view
        .annotation;
        NSLog(@"KMANNOTATION:%@",knAnnot.dataDict);
    }
    /**
     *  Push to detaild view
     */
    NSLog(@"accessory button tapped for annotation %@", view.annotation);
}
- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    //UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ttile" message:@"working" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    //[alert show];
    MKAnnotationView *view = nil;
    if(annotation != mv.userLocation) {
        // if it's NOT the user's current location pin, create the annotation
        MKPinAnnotationView *parkAnnotation = (MKPinAnnotationView*)annotation;
        // Look for an existing view to reuse
        view = [mv dequeueReusableAnnotationViewWithIdentifier:@"parkAnnotation"];
        // If an existing view is not found, create a new one
        if(view == nil) {
            view = [[MKPinAnnotationView alloc] initWithAnnotation:(id) parkAnnotation
                                                   reuseIdentifier:@"parkAnnotation"];
        }
        
        // Now we have a view for the annotation, so let's set some properties
        [(MKPinAnnotationView *)view setPinColor:MKPinAnnotationColorRed];
        [(MKPinAnnotationView *)view setAnimatesDrop:YES];
        [view setCanShowCallout:YES];
        
        // Now create buttons for the annotation view
        // The 'tag' properties are set so that we can identify which button was tapped later
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = 1;
        
        // Add buttons to annotation view
        [view setRightCalloutAccessoryView:rightButton];
    }
    
    // send this annotation view back to MKMapView so it can add it to the pin
    return view;
}

- (CLLocationCoordinate2D) useLocationString:(NSString*)lat andLong:(NSString *)lon
{
    // the location object that we want to initialize based on the string
    CLLocationCoordinate2D loc;
    
    // split the string by comma
    
    // set our latitude and longitude based on the two chunks in the string
    loc.latitude = lat.doubleValue;
    loc.longitude = lon.doubleValue;
    
    return loc;
}
- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.hospitalsMap userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.hospitalsMap annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.hospitalsMap removeAnnotations:pins];
    pins = nil;
}
@end
