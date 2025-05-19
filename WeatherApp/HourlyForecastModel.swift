import Foundation

struct HourlyForecastResponse: Codable {
    let list: [HourlyForecastItem]
}

struct HourlyForecastItem: Codable {
    let dt: TimeInterval
    let main: HourlyMainInfo
    let weather: [HourlyWeatherInfo]
    let pop: Double
    let rain: HourlyRain?
}

struct HourlyMainInfo: Codable {
    let temp: Double
}

struct HourlyWeatherInfo: Codable {
    let icon: String
}

struct HourlyRain: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
