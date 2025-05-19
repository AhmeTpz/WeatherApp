import UIKit

class ViewController: UIViewController {
    
    // Gunluk

    @IBOutlet weak var weatherCardView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelstemperatureLabel: UILabel!
    @IBOutlet weak var rainpopLabel: UILabel!
    @IBOutlet weak var rainfallLabel: UILabel!
    @IBOutlet weak var windspeedLabel: UILabel!
    @IBOutlet weak var winddegLabel: UILabel!
    
    // 5 gunluk
    
    @IBOutlet var day5Labels: [UILabel]!
    @IBOutlet var weathericon5ImageView: [UIImageView]!
    @IBOutlet var popfall5Labels: [UILabel]!
    @IBOutlet var maxmintemp5Labels: [UILabel]!
    @IBOutlet var windspeeddeg5Labels: [UILabel]!
    

    // Saatlik
    
    @IBOutlet var hoursLabel: [UILabel]!
    @IBOutlet var iconImageViews: [UIImageView]!
    @IBOutlet var tempLabels: [UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners(of: weatherCardView)
        fetchWeather(for: "Istanbul")
        fetchFiveDayForecast(for: "Istanbul")
        fetchHourlyForecast(lat: 41.0082, lon: 28.9784) // İstanbul koordinatları
        



        func roundCorners(of view: UIView, radius: CGFloat = 12) {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }

    }
    func fetchWeather(for city: String) {
        let apiKey = "e5ad3d121443bd92d34d706411ac6b91"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=tr"

        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri gelmedi")
                return
            }

            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)

                DispatchQueue.main.async {
                    self.cityLabel.text = "Sultangazi, İstanbul"
                    self.temperatureLabel.text = "\(Int(weather.main.temp))°C"
                    self.feelstemperatureLabel.text = "Hissedilen \(Int(weather.main.feels_like))°"
                    let rawDesc = weather.weather.first?.description ?? "-"
                    let capitalizedDesc = rawDesc.prefix(1).capitalized + rawDesc.dropFirst()
                    self.descriptionLabel.text = capitalizedDesc


                    self.rainfallLabel.text = "\(weather.rain?.oneHour ?? 0.0) mm"
                    self.rainpopLabel.text = "-"

                    let windSpeedKmh = weather.wind.speed * 3.6
                    self.windspeedLabel.text = String(format: "%.1f km/s", windSpeedKmh)
                    let direction = self.directionFrom(degree: weather.wind.deg)
                    self.winddegLabel.text = direction

                    self.loadWeatherIcon(named: weather.weather.first?.icon ?? "")
                }

            } catch {
                print("JSON çözümleme hatası: \(error)")
            }
        }.resume()
    }
    func directionFrom(degree: Int) -> String {
        switch degree {
        case 0..<23, 338...360: return "↑ Kuzey"
        case 23..<68:           return "↗ Kuzeydoğu"
        case 68..<113:          return "→ Doğu"
        case 113..<158:         return "↘ Güneydoğu"
        case 158..<203:         return "↓ Güney"
        case 203..<248:         return "↙ Güneybatı"
        case 248..<293:         return "← Batı"
        case 293..<338:         return "↖ Kuzeybatı"
        default: return "-"
        }
    }


    func loadWeatherIcon(named icon: String) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.weatherIconImageView.image = image
                }
            }
        }.resume()
    }
    func fetchFiveDayForecast(for city: String) {
        let apiKey = "e5ad3d121443bd92d34d706411ac6b91"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric&lang=tr"

        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri gelmedi")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ForecastResponse.self, from: data)

                // Verileri güne göre grupla
                var groupedByDay: [String: [FiveDayForecastItem]] = [:]
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

                for item in response.list {
                    if let date = inputFormatter.date(from: item.dt_txt) {
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "yyyy-MM-dd"
                        let key = dayFormatter.string(from: date)

                        groupedByDay[key, default: []].append(item)
                    }
                }

                let sortedDays = groupedByDay.keys.sorted().prefix(5)

                DispatchQueue.main.async {
                    for (index, dayKey) in sortedDays.enumerated() {
                        guard index < self.day5Labels.count,
                              let dailyItems = groupedByDay[dayKey] else { continue }

                        // Gün adı + tarih
                        let refDate = inputFormatter.date(from: dailyItems[0].dt_txt)!
                        let dayFormatter = DateFormatter()
                        dayFormatter.locale = Locale(identifier: "tr_TR")
                        dayFormatter.dateFormat = "EEEE"
                        let dayName = dayFormatter.string(from: refDate).capitalized

                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "tr_TR")
                        dateFormatter.dateFormat = "d MMM"
                        let dateStr = dateFormatter.string(from: refDate)

                        self.day5Labels[index].text = "\(dayName)\n\(dateStr)"

                        // Icon (12:00 verisi varsa o, yoksa ilk)
                        let iconItem = dailyItems.first { $0.dt_txt.contains("12:00:00") } ?? dailyItems[0]
                        self.loadForecastIcon(named: iconItem.weather.first?.icon ?? "", into: self.weathericon5ImageView[index])

                        // Yağış oranı (max %)
                        let maxPop = Int((dailyItems.map { $0.pop }.max() ?? 0.0) * 100)

                        // Yağış miktarı (toplam mm)
                        let totalRain = dailyItems.compactMap { $0.rain?.volume }.reduce(0, +)
                        let rainText = totalRain > 0 ? String(format: "%.1f mm", totalRain) : "0 mm"
                        self.popfall5Labels[index].text = "%\(maxPop)\n\(rainText)"

                        // Sıcaklıklar
                        let maxTemp = Int(dailyItems.map { $0.main.temp_max }.max() ?? 0)
                        let minTemp = Int(dailyItems.map { $0.main.temp_min }.min() ?? 0)
                        self.maxmintemp5Labels[index].text = "\(maxTemp)° / \(minTemp)°"

                        // Rüzgar
                        let windAvg = dailyItems.map { $0.wind.speed }.reduce(0, +) / Double(dailyItems.count)
                        let windDeg = dailyItems[0].wind.deg
                        let windDirection = self.directionFrom(degree: windDeg)
                        let windText = String(format: "%.0f km/s\n%@", windAvg * 3.6, windDirection)
                        self.windspeeddeg5Labels[index].text = windText
                    }
                }

            } catch {
                print("Çözümleme hatası: \(error)")
            }

        }.resume()
    }

    
    func loadForecastIcon(named icon: String, into imageView: UIImageView?) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }
        }.resume()
    }
    
    func fetchHourlyForecast(lat: Double, lon: Double) {
        let apiKey = "e5ad3d121443bd92d34d706411ac6b91"
        let urlString = "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=tr"

        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("İstek hatası: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri gelmedi")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(HourlyForecastResponse.self, from: data)

                let first24 = Array(response.list.prefix(24))
                let firstHour = response.list.first
                let rainChance = Int((firstHour?.pop ?? 0.0) * 100)
                let rainAmount = firstHour?.rain?.oneHour ?? 0.0

                DispatchQueue.main.async {
                    self.rainpopLabel.text = "%\(rainChance)"
                    self.rainfallLabel.text = rainAmount > 0 ? "\(rainAmount) mm" : "Yok"

                    for (index, item) in first24.enumerated() {
                        if index < self.hoursLabel.count {
                            let date = Date(timeIntervalSince1970: item.dt)

                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "tr_TR")
                            formatter.dateFormat = "HH:mm"

                            self.hoursLabel[index].text = formatter.string(from: date)
                            self.tempLabels[index].text = "\(Int(item.main.temp))°C"
                            self.loadForecastIcon(named: item.weather.first?.icon ?? "", into: self.iconImageViews[index])
                        }
                    }
                }

            } catch {
                print("Çözümleme hatası: \(error)")
            }
        }.resume()
    }



}
