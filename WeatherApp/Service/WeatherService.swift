//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 22/06/21.
//


import Foundation
import UIKit

protocol WeatherServiceDelegate {
    func didUpdateWeather(_ weatherService: WeatherService, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherService {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=fae7190d7e6433ec3a45285ffcf55c86&units=metric&q="
    
    var delegate: WeatherServiceDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL + cityName)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let description = decodedData.weather[0].description
            let mainDesc = decodedData.weather[0].main
            
            let temp = decodedData.main.temp
            let name = decodedData.name
            let max_temp = decodedData.main.temp_max
            let min_temp = decodedData.main.temp_min
            
            let humidity = decodedData.main.humidity
            let windSpeed = decodedData.wind.speed
            
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            
            let timezone = decodedData.timezone
            
            let weather = WeatherModel(description: description, cityName: name, temperature: temp,minTemp: min_temp,maxTemp: max_temp,mainDesc: mainDesc, humidity: humidity, speed: windSpeed,sunrise: sunrise,sunset: sunset,timezone: timezone)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

