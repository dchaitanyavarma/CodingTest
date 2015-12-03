//
//  ServiceHelper.swift
//  WeatherUpdate
//
//  Created by Chaitanya on 01/12/15.
//
//

import UIKit
import CoreLocation



class ServiceHelper: NSObject {
    
    class var sharedInstance : ServiceHelper {
        struct staticInstance
        {
            static let instance = ServiceHelper()
        }
        return staticInstance.instance
    }
    
    /**
    
    Method : To fetch the weather details for particular location.
    param : location : the coordinates for which weather has to be found.
    param : responseBlock : Execution returns to this block after completion.
    
    */
    
    func getWeatherForLocation(location:CLLocation,successBlock : (weatherObject: WeatherDetails) -> (), failureBlock:( weatherError: NSError) -> ())
    {
        let weatherUpdate = WeatherDetails()
        let session = NSURLSession(configuration:NSURLSessionConfiguration.defaultSessionConfiguration())
        let requestURL = NSURL(string:WEATHERURL + APIKEY + "/" + "\(location.coordinate.latitude),\(location.coordinate.longitude)")
        let request =  NSMutableURLRequest(URL: requestURL!)
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data,response,error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse
            {
                
                if (httpResponse.statusCode == SUCESS_STATUSCODE)
                {
                    var responseDictionary : NSDictionary!
                    
                    do{
                        responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                    } catch let jsonError as NSError
                    {
                        failureBlock(weatherError:jsonError)
                    }
                    
                    if (responseDictionary != NSNull())
                    {
                        let dataDictionary = responseDictionary["currently"] as! NSDictionary
                        weatherUpdate.summary = dataDictionary["summary"] as! String
                        if let pressureValue = dataDictionary["pressure"]
                        {
                            weatherUpdate.pressure = "\(pressureValue)"
                            
                        }
                       if let temperatureValue = dataDictionary["temperature"]
                        {
                            weatherUpdate.temperature = "\(temperatureValue)"
                            
                        }
                        if let humidityValue = dataDictionary["humidity"]
                        {
                            weatherUpdate.humidity = "\(humidityValue)"
                        }
                        
                        successBlock(weatherObject: weatherUpdate)
                        
                    }
                    
                }
                else
                {
                   
                    failureBlock(weatherError:error!)
                    
                    
                }
            }
            
            
        })
        dataTask.resume()
        
        
    }
    
}
