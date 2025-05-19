import Foundation

struct ForecastResponse: Codable {
    let list: [FiveDayForecastItem]
}

struct FiveDayForecastItem: Codable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [ForecastWeather]
    let pop: Double
    let rain: RainVolume?
    let wind: WindInfo
    let dt_txt: String
}

struct ForecastMain: Codable {
    let temp_min: Double
    let temp_max: Double
}

struct ForecastWeather: Codable {
    let icon: String
}

struct RainVolume: Codable {
    let volume: Double?

    enum CodingKeys: String, CodingKey {
        case volume = "3h"
    }
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}
