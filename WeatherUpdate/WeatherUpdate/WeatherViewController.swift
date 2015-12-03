//
//  WeatherViewController.swift
//  WeatherUpdate
//
//  Created by Chaitanya on 01/12/15.
//
//

import UIKit
import CoreLocation

class WeatherViewController: UITableViewController,CLLocationManagerDelegate {
    
  
   
    @IBOutlet weak var activityindicatorView: UIActivityIndicatorView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
   
    
   
    let locationManager = CLLocationManager()
    var locationObject = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
       super.viewDidAppear(true)
        self.getLocationDetails()
    }
    
    // MARK: - Initiate Location Update
    /**
    method: This method is triggered when you click the refresh button for weather update
    */
    @IBAction func refreshWeather(sender: AnyObject) {
    
        self.getLocationDetails()
    
        
    }
    
    /**
    method : This method initaites the location update
    
    */
    func getLocationDetails()
    {
        if(Reachability.reachabilityForInternetConnection().currentReachabilityStatus() == NotReachable)
        {
            let alertView = UIAlertController(title: "Network Status", message: "Kindly check your network connection", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
        }
        else
        {
        self.activityindicatorView.hidden = false
        self.activityindicatorView.startAnimating()
        if(CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        else
        {
            let alertView = UIAlertController(title: "", message: "Kindly enable location services under settings", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            self.activityindicatorView.stopAnimating()
            
        }
        }

        
        
    }
    
    // MARK: - Location Manager Delegate Methods
   
    /**
    method : call back method when location manager failed to get the location.
    param : manager, The locationmanager which invoked this delegate method.
    param : error, The error object retrieved
    
    */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
        if(error != NSNull()){
           
            self.displayAlertWithError(error)
            locationManager.stopUpdatingLocation()
        }
        self.activityindicatorView.stopAnimating()
    }
    /*
    method : call back method when the locaiton is updated.
    param : manager, The locationmanager which invoked this delegate method.
    param : locations, Array of possible locations retrieved.
    
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let locationArray = locations as NSArray
        locationObject = locationArray.lastObject as! CLLocation
        if(locationObject != NSNull())
        {
        locationManager.stopUpdatingLocation()
        self.getWeatherDetails()
      
        }
        
    }
    
    // MARK: - Weather Service call
    /**
    method : This method does the actual service call for weather updates

    */
    func getWeatherDetails()
    {
        
        
        let serviceHelperObj = ServiceHelper.sharedInstance
        serviceHelperObj.getWeatherForLocation(locationObject,successBlock: { (weatherObject:WeatherDetails) ->() in
            
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.updateWeatherDetails(weatherObject)
            })}, failureBlock: { (weatherError: NSError) ->() in
                
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.displayAlertWithError(weatherError)
                })
                
             
        })
        
        self.activityindicatorView.stopAnimating()
        
    }
    
    // MARK: - Error Display on UI
    /**
    method : To display alert message when something is wrong.
    param : error object whose localized description is shown.
    
    */
    func displayAlertWithError(error:NSError) {
        let alertView = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
       alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    
    }
    
    // MARK: - Update Weather on UI
    /**
    Method : This method updates the UI with all weather details
    param : weather object which has information about the weather.
    */
    func updateWeatherDetails(weatherObject:WeatherDetails){
        
        
       self.pressureLabel.text = PRESSURE_STRING + ":\t" + weatherObject.pressure
       self.summaryLabel.text = SUMMARY_STRING + ":\t" + weatherObject.summary
       self.temperatureLabel.text =  TEMPERATURE_STRING + ":\t" + weatherObject.temperature
       self.humidityLabel.text =  HUMIDITY_STRING + ":\t" + weatherObject.humidity
        
        
    }
    // MARK: - ViewController Delegate Methods
    override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(false)
    if(locationManager != NSNull())
    {
     locationManager.stopUpdatingLocation()
    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UNIT TESTING METHODS
    func summaryLabelText(weatherObject:WeatherDetails) ->String {
        
        return weatherObject.summary
        
    }
    
    func humidityLabelText(weatherObject:WeatherDetails) -> String {
        
        return weatherObject.humidity
    }
    


}

