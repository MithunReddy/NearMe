//
//  KMAnnotation.h
//  NearMe
//
//  Created by nunc03 on 5/1/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface KMAnnotation : MKPointAnnotation <MKMapViewDelegate>
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSDictionary *dataDict;

@end
