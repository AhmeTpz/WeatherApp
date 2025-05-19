import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let rain: Rain?
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double?
    let temp_max: Double?
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Rain: Codable {
    let oneHour: Double?

    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
}
