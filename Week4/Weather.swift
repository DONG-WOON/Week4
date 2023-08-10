//
//  Weather.swift
//  Week4
//
//  Created by 서동운 on 8/8/23.
//

import Foundation

// MARK: - Welcome
struct WeatherData: Codable {
    let main: Main
    let dt: Int
    let weather: [Weather]
    let cod: Int
    let base: String
    let id: Int
    let name: String
    let coord: Coord
    let timezone, visibility: Int
    let sys: Sys
    let wind: Wind
    let clouds: Clouds
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike: Double
    let pressure: Int
    let tempMax, tempMin: Double
    let grndLevel, seaLevel, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case grndLevel = "grnd_level"
        case seaLevel = "sea_level"
        case humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sunset: Int
    let country: String
    let id, sunrise, type: Int
}

// MARK: - Weather
struct Weather: Codable {
    let main: String
    let id: Int
    let icon, description: String
}

// MARK: - Wind
struct Wind: Codable {
    let gust, speed: Double
    let deg: Int
}
