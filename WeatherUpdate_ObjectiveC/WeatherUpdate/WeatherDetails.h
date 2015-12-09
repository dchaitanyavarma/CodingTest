//
//  WeatherDetails.h
//  WeatherUpdate
//
//  Created by Mobility on 12/9/15.
//
//

#import <Foundation/Foundation.h>

@interface WeatherDetails : NSObject

@property(nonatomic,strong) NSString *summary;
@property(nonatomic,strong) NSString *temperature;
@property(nonatomic,strong) NSString *humidity;
@property(nonatomic,strong) NSString *pressure;

@end
