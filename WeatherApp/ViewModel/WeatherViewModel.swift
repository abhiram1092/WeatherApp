//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import Foundation

class WeatherViewModel  {
    
    private var weatherAPI : WeatherService?
    
    init(weatherAPI: WeatherService) {
        self.weatherAPI = weatherAPI
        self.weatherAPI?.delegate = self
    }
    
    var error: Error? {
        didSet {
            self.showAlertClosure?()
        }
    }
    var weatherModel : WeatherModel? {
        didSet {
            print(weatherModel!)
            guard weatherModel != nil  else { return }
            self.didFinishFetch?(weatherModel ?? nil)
        }
    }
    
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var didFinishFetch: ((_ : WeatherModel?) -> ())?
    
    func fetchWeatherData(cityName : String) {
        self.weatherAPI?.fetchWeather(cityName: cityName)
    }
}
extension WeatherViewModel : WeatherServiceDelegate {
    func didUpdateWeather(_ weatherService: WeatherService, weather: WeatherModel) {
        self.weatherModel = weather
    }
    func didFailWithError(error: Error) {
        self.error = error
    }
    
    
}
