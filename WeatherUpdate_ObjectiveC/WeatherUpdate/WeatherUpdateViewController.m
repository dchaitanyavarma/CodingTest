//
//  WeatherViewController.m
//  WeatherUpdate
//
//  Created by Mobility on 12/9/15.
//
//

#import "WeatherUpdateViewController.h"

@interface WeatherUpdateViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong) NSString* locationCoordinates;
@property (nonatomic,strong) CLLocationManager *cLLocationManager;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property(nonatomic,strong) ServiceHelper *serviceHelper;

@end

@implementation WeatherUpdateViewController

#pragma mark -- View Life Cycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.serviceHelper = [ServiceHelper sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getLocationDetails];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(self.cLLocationManager != nil)
    [self.cLLocationManager stopUpdatingLocation];
    self.activityIndicator.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- IBAction Methods
/*
 method: This method is triggered when you click the refresh button for weather update
 */

- (IBAction)refreshWeather:(id)sender {
    [self getLocationDetails];
}


#pragma mark -- Helper Methods
/**
 method : This method initaites the location update
 
 */

-(void) getLocationDetails
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)
        {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:@"Kindly check your internet connection" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertView animated:YES completion:nil];
 
        }
        else
         [self.cLLocationManager startUpdatingLocation];
    }
    else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:@"Kindly enable location services" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
    
}

/**
 method : This method does the actual service call for weather updates
 
 */
-(void) getWeatherDetails
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",WEATHERURL,self.locationCoordinates];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.serviceHelper responseForURL:url withSuccessHandler:^(NSDictionary *responseDict) {
        if(responseDict)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self updateUserInterfaceForWeatherForecastServiceCall:NO];
                //[self setviewAttributes:[self parseResponse:responseDict]];
                self.refreshButton.userInteractionEnabled = YES;
                self.activityIndicator.hidden = YES;
                [self setWeatherDetails:[self fetchDetailsResponse:responseDict]];
            });
        }
    } errorHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.refreshButton.userInteractionEnabled = YES;
            self.activityIndicator.hidden = YES;
            [self displayAlertWithError:error];
        });
    }];

    
}

/*
 Method : This method returns the weather details object from service response dictionary
 param : dictionary which holds the respons information.
 */
-(WeatherDetails*)fetchDetailsResponse:(NSDictionary*)responseDictionary
{
    WeatherDetails *weatherDetails = [[WeatherDetails alloc]init];
    
    weatherDetails.summary = [responseDictionary[@"currently"] objectForKey:@"summary"];
    weatherDetails.temperature = [responseDictionary[@"currently"]objectForKey:@"temperature"];
    weatherDetails.humidity = [responseDictionary[@"currently"]objectForKey:@"humidity"];
    weatherDetails.pressure = [responseDictionary[@"currently"]objectForKey:@"pressure"];
    
   /*    if(currWeatherModel.summary.length>1)
    {
        [self updateView:currWeatherModel.summary];
    }*/
    return weatherDetails;
}

/*
 Method : This method updates the UI with all weather details
 param : weather object which has information about the weather.
 */

-(void)setWeatherDetails:(WeatherDetails *)weatherDetails
{
    
    self.pressureLabel.text = [NSString stringWithFormat:@"%@:\t%@",PRESSURE_STRING,weatherDetails.pressure];
    self.summaryLabel.text = [NSString stringWithFormat:@"%@:\t%@",SUMMARY_STRING,weatherDetails.summary];
    self.temperatureLabel.text =  [NSString stringWithFormat:@"%@:\t%@",TEMPERATURE_STRING,weatherDetails.temperature];
    self.humidityLabel.text =  [NSString stringWithFormat:@"%@:\t%@",HUMIDITY_STRING, weatherDetails.humidity];
    
}

/*
 
 Method Name  : cLLocationManager
 Description  : getter for LocationManager
 
 */
-(CLLocationManager*)cLLocationManager{
    
    if(!_cLLocationManager)
    {
        _cLLocationManager = [[CLLocationManager alloc] init];
        _cLLocationManager.delegate = self;
        _cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
         [_cLLocationManager requestWhenInUseAuthorization];
    }
    return _cLLocationManager;
    
}

/*
 method : To display alert message when something is wrong.
 param : error object whose localized description is shown.
 
 */
-(void)displayAlertWithError:(NSError *)error {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertView animated:YES completion:nil];
    
}


#pragma mark -- Location Manager Delegate Methods

/*
 method : call back method when the locaiton is updated.
 param : manager, The locationmanager which invoked this delegate method.
 param : locations, Array of possible locations retrieved.
 
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    //NSLog(@"%@ response",currentLocation);
    if(currentLocation != nil)
    {
    self.locationCoordinates = [NSString stringWithFormat:@"%f,%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude];
    
        
    if(self.locationCoordinates.length>1)
    {
  
        self.refreshButton.userInteractionEnabled = NO;
        self.activityIndicator.hidden = NO;
        [self getWeatherDetails];
    }
    else{
      
        self.refreshButton.userInteractionEnabled = YES;
        self.activityIndicator.hidden = YES;
    }
    }
    else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:@"Unable to retrieve location details.Please try again" preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertView animated:YES completion:nil];
 
    }
    [self.cLLocationManager stopUpdatingLocation];
    
}

/*
 method : call back method when location manager failed to get the location.
 param : manager, The locationmanager which invoked this delegate method.
 param : error, The error object retrieved
 
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(error != nil){
        
        [self displayAlertWithError:error];
        [self.cLLocationManager stopUpdatingLocation];
    }

}

#pragma mark -- Methods for Unit testing
/*
 
 Method Name  : summaryLabelText
 Description  : to get summary text for unittest case
 
 */

-(NSString *)summaryLabelText
{
   NSString *summaryText = [[self.summaryLabel.text componentsSeparatedByString:@"\t"] lastObject];
   return summaryText;
}

/*
 
 Method Name  : temperatureLabelText
 Description  : to get temperature text for unittest case
 
 */

-(NSString *)temperatureLabelText
{
    NSString *temperatureText = [[self.temperatureLabel.text componentsSeparatedByString:@"\t"] lastObject];
    return temperatureText;
}


@end
