//
//  DetailViewController.h
//  NearMe
//
//  Created by nunc03 on 5/1/15.
//  Copyright (c) 2015 Mithun Reddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)NSDictionary *dataDict;

@end
