//
//  UIImage+MFXAddition.m
//  MFXLibrary
//
//  Created by Prince Ugwuh on 7/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Category.h"


@implementation UIImage (Category)

- (UIImage *)thumbWithSideOfLength:(float)length {

	UIImage *thumbnail;

	UIImageView *imageView = [[UIImageView alloc] initWithImage:self];
	BOOL widthGreaterThanHeight = (self.size.width > self.size.height);
	float sideFull = (widthGreaterThanHeight) ? self.size.height : self.size.width;
	CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
	//creating a square context the size of the final image which we will then
	// manipulate and transform before drawing in the original image
	UIGraphicsBeginImageContext(CGSizeMake(length, length));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextClipToRect( currentContext, clippedRect);
	CGFloat scaleFactor = length/sideFull;
	
	if (widthGreaterThanHeight) {
	  
		//a landscape image - make context shift the original image to the left when drawn into the context
		CGContextTranslateCTM(currentContext, -((self.size.width - sideFull) / 2) * scaleFactor, 0);
	}
	else {
	
		//a portfolio image - make context shift the original image upwards when drawn into the context
		CGContextTranslateCTM(currentContext, 0, -((self.size.height - sideFull) / 2) * scaleFactor);
	}
	
	//this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
	CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
	[imageView.layer renderInContext:currentContext];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *imageData = UIImagePNGRepresentation(thumbnail);

	thumbnail = [UIImage imageWithData:imageData];

	return thumbnail;
}

@end
