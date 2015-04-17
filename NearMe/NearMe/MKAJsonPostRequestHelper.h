//
//  MKAJsonhHelper.h
//  RequestExample
//
//  Created by nunc03 on 11/24/14.
//  Copyright (c) 2014 Mithun Reddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
typedef void (^JSONResponseBlock)(NSDictionary* json);
@interface MKAJsonPostRequestHelper : NSObject
+(void)executeWithParams:(NSDictionary *)inParams andPostMethod:(NSString *)inMethod onCompletion:(JSONResponseBlock)completionBlock;
+(void)executeWithUrl:(NSURL *)inUrl onCompletion:(JSONResponseBlock)completionBlock;
@property(nonatomic,assign)id delegateid;

@end
