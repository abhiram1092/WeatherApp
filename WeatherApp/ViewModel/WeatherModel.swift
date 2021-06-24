//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import Foundation

struct WeatherModel {
    
    let description: String
    let cityName: String
    let temperature: Double
    let minTemp : Double
    let maxTemp : Double
    let mainDesc : String
    
    let humidity : Double
    let speed : Double
    
    let sunrise : Double
    let sunset : Double
    
    let timezone : Double
    
    
    
    var humidityString : String {
        return "\(String(format: "%.1f", humidity))%"
    }
    var winSpeedString : String {
        return String(format: "%.2f m/sec", speed)
    }
    
    var temperatureString: String {
        return String(format: "%.1f°", temperature)
    }
    var minTempString : String {
        return String(format: "%.1f°", minTemp)
    }
    var maxTempString : String {
        return String(format: "%.1f°", maxTemp)
    }
    func updateBackgroundImage(description : String) -> String {
        switch description {
        case "scattered clouds", "broken clouds", "few clouds", "overcast clouds":
            return "clouds"
        case "shower rain", "rain", "light rain", "moderate rain":
            return "rain"
        case "thunderstorm" :
            return "thunders"
        case "snow", "mist" :
            return "mist_snow"
        case "clear sky" :
            return "backgroundImg"
        default:
            return "backgroundImg"
            
        }
    }
    
    
    
}
