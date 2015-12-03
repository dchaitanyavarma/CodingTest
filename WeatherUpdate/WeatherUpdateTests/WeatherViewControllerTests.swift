//
//  WeatherViewControllerTests.swift
//  WeatherUpdate
//
//  Created by chaitanya on 12/3/15.
//
//

import XCTest
import UIKit
import WeatherUpdate



class WeatherViewControllerTests: XCTestCase {
    
    
    
    var weatherViewController = WeatherViewController()
    
    var weatherObject:WeatherDetails = WeatherDetails()
    
    override func setUp() {
        super.setUp()
        weatherObject.summary = "Summary";
        weatherObject.temperature = "47.08"
        weatherObject.humidity = "0.05"
        weatherObject.pressure = "1067.25"
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
  func testSummaryAttribute() {
    //weatherViewController.updateWeatherDetails(weatherObject)
    XCTAssertEqual(weatherViewController.summaryLabelText(weatherObject),"Summary","Summary field is tested");
    
    }
    
    func testHumidityAttribute() {
        XCTAssertNotEqual(weatherViewController.humidityLabelText(weatherObject),"0.06","Humidity field is tested");
        
    }
    

    
    

    
}
