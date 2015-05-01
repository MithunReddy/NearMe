//
//  UIImage_MFXAddition.h
//  MFXLibrary
//
//  Created by Prince Ugwuh on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Category.h"

@interface UIImageView (Category) 


@property(nonatomic, assign) BOOL useThumb;
@property(nonatomic, assign) CGFloat thumbSize;

- (void)loadFromURL:(NSURL *)url;
- (void)loadFromURL:(NSURL *)url afterDelay:(float)delay;

@end
