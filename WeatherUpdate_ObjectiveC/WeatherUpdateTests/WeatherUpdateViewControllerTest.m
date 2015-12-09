//
//  WeatherUpdateViewControllerTest.m
//  WeatherUpdate
//
//  Created by Gopal on 12/9/15.
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "WeatherUpdateViewController.h"
#import "WeatherDetails.h"
#import "Constants.h"


@interface WeatherUpdateViewController()

-(NSString *)summaryLabelText;
-(NSString *)temperatureLabelText;
-(WeatherDetails*)fetchDetailsResponse:(NSDictionary*)responseDictionary;
-(void)setWeatherDetails:(WeatherDetails *)weatherDetails;


@end

@interface WeatherUpdateViewControllerTest : XCTestCase

@property(nonatomic,strong) WeatherUpdateViewController *weatherViewControllerTest;

@end

@implementation WeatherUpdateViewControllerTest

- (void)setUp {
    [super setUp];
     self.weatherViewControllerTest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeatherUpdateViewController"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.weatherViewControllerTest = nil;
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/*
 
 Method Name  : testfetchedResponse
 Description  : to UNIT TEST parseResponse method in ViewController
 
 */

-(void)testfetchedResponse
{
    WeatherDetails* weatherObject = [self.weatherViewControllerTest fetchDetailsResponse:@{@"currently":@{@"summary":@"cloudy"}}];
    XCTAssertEqual(weatherObject.summary, @"cloudy",@"Pass");
    
}

/*
 
 Method Name  : testWeatherAttributes
 Description  : to UNIT TEST parseResponse method in ViewController
 
 */

-(void)testWeatherAttributes {
    
    WeatherDetails *weatherObject = [[WeatherDetails alloc]init];
    weatherObject.summary = @"cloudy";
    weatherObject.temperature = @"56.09";
    weatherObject.humidity = @"0.03";
    weatherObject.pressure = @"3.57";
     [_weatherViewControllerTest setWeatherDetails:weatherObject];
    
  XCTAssertEqual([_weatherViewControllerTest summaryLabelText],@"cloudy",@"Model objects are not assigned to UI");
    XCTAssertNotEqual([_weatherViewControllerTest temperatureLabelText],@"11.20",@"temperature validation is done");
    
}



@end
