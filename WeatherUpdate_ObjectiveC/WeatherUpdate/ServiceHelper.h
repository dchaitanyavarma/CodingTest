//
//  ServiceHelper.h
//  WeatherUpdate
//
//  Created by Mobility on 12/9/15.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ServiceHelper : NSObject

+(ServiceHelper*)sharedInstance;

-(void)responseForURL:(NSURL*)url withSuccessHandler:(void (^)(NSDictionary*))onSuccess errorHandler:(void (^)(NSError*))onError;

@end
