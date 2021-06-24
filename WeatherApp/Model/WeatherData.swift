//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let wind : Wind
    let sys : Sys
    let timezone : Double
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity : Double
    let temp_max : Double
    let temp_min : Double
    
}
struct Wind : Codable {
    let speed : Double
}
struct Sys : Codable {
    let sunrise : Double
    let sunset : Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let id : Int
    let icon : String
}
