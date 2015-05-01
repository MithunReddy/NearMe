//
//  UIImage_MFXAddition.m
//  MFXLibrary
//
//  Created by Prince Ugwuh on 7/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+Category.h"
#define MAX_CACHED_IMAGES 1

static BOOL _useThumb = NO;
static CGFloat _thumbSize = 75;

@interface UIImageView (Private)

- (NSMutableDictionary*)cache;
- (void)cacheFromURL:(NSURL*)url;

@end


@implementation UIImageView (Category)
			
@dynamic useThumb;
@dynamic thumbSize;


- (BOOL)useThumb {
	
	return _useThumb;
}
-(void)setUseThumb:(BOOL)value {
	
	_useThumb = value;
}

- (CGFloat)thumbSize {
	
	return _thumbSize;
}
- (void)setThumbSize:(CGFloat)value {
	
	_thumbSize = value;
}

- (void)loadFromURL:(NSURL *)url {
	
	[self performSelectorInBackground:@selector(cacheFromURL:) withObject:url]; 
}

- (void)loadFromURL:(NSURL*)url afterDelay:(float)delay {
	
	[self performSelector:@selector(loadFromURL:) withObject:url afterDelay:delay];
}

- (void)cacheFromURL:(NSURL*)url {

	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIImage *newImage = [[self imageCache] objectForKey:url.description];

	if(!newImage) {
		
		NSError *err = nil;
		newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url options:0 error:&err]];
		
		if(err == nil) {
		
			if(newImage) {
				
				//check
				if([[self imageCache] count] >= MAX_CACHED_IMAGES) {
					
					[[self imageCache] removeAllObjects];
					[[self imageCache] setValue:newImage forKey:url.description];
				}
				
			}
			
			if(newImage) {
				
				if(self.useThumb) {
					
					[self performSelectorOnMainThread:@selector(setImage:) withObject:[newImage thumbWithSideOfLength:self.thumbSize] waitUntilDone:NO];
				} else {
					
					[self performSelectorOnMainThread:@selector(setImage:) withObject:newImage waitUntilDone:NO];
				}
			} 
		} else {
			//NSLog(@"Image failed to load %@",err);
		}
	}
	//[pool drain];
}
- (NSMutableDictionary*)imageCache {
    
    static NSMutableDictionary* _cache = nil;
    
    if(!_cache)
        _cache = [NSMutableDictionary dictionaryWithCapacity:MAX_CACHED_IMAGES] ;
    
    assert(_cache);
    return _cache;
}
@end
