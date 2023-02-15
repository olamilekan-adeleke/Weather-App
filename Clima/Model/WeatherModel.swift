//
//  WeatherModel.swift
//  Clima
//
//  Created by Enigma Kod on 13/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

class WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    func getWeatherImage() -> String {
//        if icon.contains("n") {
//            return "night.cloud"
//        }

        switch id {
            case 200...232:
                return "cloud.lighting"
            case 300...321:
                return "cloud.rain"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "sunny.cloud"
            case 701...781:
                return "cloud.rain"
            case 800:
                return "sunny"
            case 801...804:
                return "cloud.lighting"
            default:
                return "sunny"
        }
    }
}

// MARK: - Main

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let pressure: Int

    func getTemp() -> String {
        return String(format: "%.2f", temp)
    }

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Wind

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
