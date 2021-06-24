//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Abhiram Sarvadevabhatla on 22/06/21.
//

import XCTest
import  CoreLocation

@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    let weatherService = WeatherService()
    let weatherVC = WeatherVC()
    let addLocationsVC = AddLocationsVC()
    
    func testingWeatherURL() {
        XCTAssertTrue(weatherService.weatherURL == "https://api.openweathermap.org/data/2.5/weather?appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric&q=\(weatherVC.cityName)")
    }
    
    func testGetWeatherInfoResults() {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric&qLondon")
        let session = URLSession(configuration: .default)
        let expected = expectation(description: "callback happened")
        
        session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                XCTAssertNotNil(error)
                XCTAssertNil(data)
            }else {
                XCTAssertNotNil(data)
                XCTAssertNil(error)
            }
            expected.fulfill()
        }.resume()
        wait(for: [expected], timeout: 10)
    }
    func testDecoding() throws {
        if let path = Bundle.main.path(forResource: "weather", ofType: "json") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            XCTAssertNoThrow(try JSONDecoder().decode(WeatherData.self, from: data))
        }
    }
    func testCheckingRightGeoCode() {
        let expected = expectation(description: "Wait for geocode")
            CLGeocoder().geocodeAddressString("Paris") {
                (placemarks, error) -> Void in
                let placemark = placemarks?.first

                let coordinate = placemark?.location?.coordinate
                guard let latitude = coordinate?.latitude else {
                    XCTFail(); return
                }
                guard let longitude = coordinate?.longitude else {
                    XCTFail(); return
                }
                XCTAssertEqual(latitude, 48.8566419, accuracy: 0.000001)
                XCTAssertEqual(longitude, 2.3518481, accuracy: 0.000001)

                expected.fulfill()
            }
        wait(for: [expected], timeout: 5.0)
    }
    func testCheckingReverseGeoCode() {
        let expected = expectation(description: "Wait for geocode")
        CLGeocoder().reverseGeocodeLocation(CLLocation.init(latitude: 37.3316851, longitude: -122.0300674)) { (placemarks, error) in
            let placemark = placemarks?.first
            
            let countryName = placemark?.country
            let cityName = placemark?.locality
            guard let name = countryName else {
                XCTFail(); return
            }
            guard let localityName = cityName else {
                XCTFail(); return
            }
            XCTAssertEqual(name, "United States")
            XCTAssertEqual(localityName, "Cupertino")
            expected.fulfill()
        }
        wait(for: [expected], timeout: 5.0)
    }
    
}
