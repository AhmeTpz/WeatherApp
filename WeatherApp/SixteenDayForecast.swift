// 16 günlük hava durumu tahminlerinin model dosyasıdır.

import Foundation

struct SixteenDayResponse: Decodable {
    let list: [SixteenDayForecastItem]
}

struct SixteenDayForecastItem: Decodable {
    let dt: TimeInterval
    let temp: Temperature
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg: Int
    let pop: Double
    let rain: Double?

    struct Temperature: Decodable {
        let min: Double
        let max: Double
    }

    struct FeelsLike: Decodable {
        let day: Double
    }

    struct Weather: Decodable {
        let description: String
        let icon: String
    }
}
