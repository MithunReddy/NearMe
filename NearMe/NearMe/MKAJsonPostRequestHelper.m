//
//  MKAJsonhHelper.m
//  RequestExample
//
//  Created by nunc03 on 11/24/14.
//  Copyright (c) 2014 Mithun Reddy. All rights reserved.
//

#import "MKAJsonPostRequestHelper.h"

@implementation MKAJsonPostRequestHelper
@synthesize delegateid;

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(MKAJsonPostRequestHelper*)sharedInstance {
    static MKAJsonPostRequestHelper *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}
#pragma mark - init
//intialize the API class with the deistination host name

-(MKAJsonPostRequestHelper*)init {
    //call super init
    if (self = [super init]) {
        //initialize the object

    }
    return self;
}

+(void)executeWithParams:(NSDictionary *)inParams andPostMethod:(NSString *)inMethod onCompletion:(JSONResponseBlock)completionBlock{

}
+(void)executeWithUrl:(NSURL *)inUrl onCompletion:(JSONResponseBlock)completionBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:inUrl];
    [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"application/json;charset=UTF-8", @"Content-Type", nil]];
    [request setRequestMethod:@"GET"];
    [request setCompletionBlock:^{
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        //NSLog(@"responce recived:%@",responseString);
        NSError *error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:kNilOptions
                              error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(json);
        });
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"responce failed :%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
        });
    }];
    
    [request startSynchronous];
 });
}
+(NSString *)jsonStringFromDictionary:(NSDictionary *)inDict{
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inDict options:0 error:&writeError];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON Input: %@", jsonString);
    return jsonString;
}
@end
