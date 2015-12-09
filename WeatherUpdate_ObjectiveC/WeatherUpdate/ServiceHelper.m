//
//  ServiceHelper.m
//  WeatherUpdate
//
//  Created by Mobility on 12/9/15.
//
//

#import "ServiceHelper.h"

@implementation ServiceHelper

static ServiceHelper *sharedInstance = nil;

/*
 
 Method Name  : sharedInstance
 Description  : to retrieve shared instance for Service Helper
 
 */

+(ServiceHelper*)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[ServiceHelper alloc]init];
    }
    return sharedInstance;
}

/*
 
 Method : To fetch the weather details for particular location.
 param : location : the coordinates for which weather has to be found.
 param : responseBlock : Execution returns to this block after completion.
 
 */

-(void)responseForURL:(NSURL*)url withSuccessHandler:(void (^)(NSDictionary*))onSuccess errorHandler:(void (^)(NSError*))onError
{
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
       
        if([(NSHTTPURLResponse *)response statusCode] == SUCESS_CODE)
        {
            NSDictionary * responseDict = nil;
            if(data != nil && data.length > 1)
            {
                responseDict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                onSuccess(responseDict);
            }else
            {
                onError(error);
            }

            
        }
        else
        {
            onError(error);
        }
    }];
    [dataTask resume] ;

}


    



@end
