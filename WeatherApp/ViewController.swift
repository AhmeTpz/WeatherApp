import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
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
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners(of: weatherCardView)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        func roundCorners(of view: UIView, radius: CGFloat = 12) {
            view.layer.cornerRadius = radius
            view.layer.masksToBounds = true
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first {
                    let city = placemark.administrativeArea ?? ""
                    let district = placemark.subAdministrativeArea ?? ""
                    let combined = "\(city), \(district)"

                    DispatchQueue.main.async {
                        self.cityLabel.text = combined
                    }
                } else {
                    DispatchQueue.main.async {
                        self.cityLabel.text = "Konum bulunamadı"
                    }
                }
            }


            // HAVA DURUMU FONKSİYONLARI
            fetchWeather(lat: lat, lon: lon)
            fetchFiveDayForecast(lat: lat, lon: lon)
            fetchHourlyForecast(lat: lat, lon: lon)
        }
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Konum alınamadı: \(error.localizedDescription)")
    }

    
    func localIconName(for code: String) -> String {
        switch code {
        case "01d": return "clear_day"
        case "01n": return "clear_night"
        case "02d": return "partly_cloudy_day"
        case "02n": return "partly_cloudy_night"
        case "03d": return "cloudy_day"
        case "03n": return "cloudy_night"
        case "04d", "04n": return "overcast"
        case "09d", "09n": return "shower_rain"
        case "10d": return "rain_day"
        case "10n": return "rain_night"
        case "11d", "11n": return "thunder"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "mist"
        default: return "default_icon"
        }
    }

    func fetchWeather(lat: Double, lon: Double) {
        let apiKey = APIkey.weatherAPIKey
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=tr"

        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }
        struct SysInfo: Codable {
            let sunrise: TimeInterval
            let sunset: TimeInterval
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
                    self.temperatureLabel.text = "\(Int(weather.main.temp))°C"
                    self.feelstemperatureLabel.text = "Hissedilen \(Int(weather.main.feels_like))°"
                    let rawDesc = weather.weather.first?.description ?? "-"
                    let capitalizedDesc = rawDesc.prefix(1).capitalized + rawDesc.dropFirst()
                    self.descriptionLabel.text = capitalizedDesc

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


    func loadWeatherIcon(named iconCode: String) {
        let imageName = localIconName(for: iconCode)
        self.weatherIconImageView.image = UIImage(named: imageName)
    }

    func fetchFiveDayForecast(lat: Double, lon: Double) {
        let apiKey = APIkey.weatherAPIKey
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=tr"

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

                var groupedByDay: [String: [FiveDayForecastItem]] = [:]
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                for item in response.list {
                    if let date = inputFormatter.date(from: item.dt_txt) {
                        let dayFormatter = DateFormatter()
                        dayFormatter.dateFormat = "yyyy-MM-dd"
                        dayFormatter.timeZone = TimeZone(secondsFromGMT: 0) // API UTC
                        let key = dayFormatter.string(from: date)
                        groupedByDay[key, default: []].append(item)
                    }
                }

                // Saat düzenlemeleri
                var utcCalendar = Calendar(identifier: .gregorian)
                utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!
                let todayUTC = utcCalendar.startOfDay(for: Date())

                let dateParser = DateFormatter()
                dateParser.dateFormat = "yyyy-MM-dd"
                dateParser.timeZone = TimeZone(secondsFromGMT: 0)

                let sortedKeys = groupedByDay.keys
                    .filter {
                        guard let date = dateParser.date(from: $0) else { return false }
                        return date > todayUTC
                    }
                    .sorted()
                    .prefix(5)

                DispatchQueue.main.async {
                    for (index, dayKey) in sortedKeys.enumerated() {
                        guard index < self.day5Labels.count,
                              let dailyItems = groupedByDay[dayKey] else { continue }

                        // Gün ismi ve tarih: yerel saat
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

                        // Icon
                        let iconItem = dailyItems.first(where: { $0.weather.first?.icon.contains("09") == true || $0.weather.first?.icon.contains("10") == true }) ??
                                       dailyItems.first(where: { $0.dt_txt.contains("12:00:00") }) ??
                                       dailyItems.first

                        self.loadForecastIcon(named: iconItem?.weather.first?.icon ?? "", into: self.weathericon5ImageView[index])

                        // Yağış
                        let maxPop = Int((dailyItems.map { $0.pop }.max() ?? 0.0) * 100)
                        let totalRain = dailyItems.map { $0.rain?.volume ?? 0.0 }.reduce(0, +)
                        let rainText = totalRain > 0 ? String(format: "%.1f mm", totalRain) : "0 mm"
                        self.popfall5Labels[index].text = "💧%\(maxPop)\n\(rainText)"

                        // Sıcaklık
                        let maxTemp = Int(dailyItems.map { $0.main.temp_max }.max() ?? 0)
                        let minTemp = Int(dailyItems.map { $0.main.temp_min }.min() ?? 0)
                        self.maxmintemp5Labels[index].text = "\(maxTemp)° / \(minTemp)°"

                        // Rüzgar
                        let windSpeedKmh = dailyItems[0].wind.speed * 3.6
                        let windDeg = dailyItems[0].wind.deg
                        let windText = String(format: "%.0f km/s\n%@", windSpeedKmh, self.directionFrom(degree: windDeg))
                        self.windspeeddeg5Labels[index].text = windText


                    }
                }

            } catch {
                print("Çözümleme hatası: \(error)")
            }

        }.resume()
    }



    
    func loadForecastIcon(named iconCode: String, into imageView: UIImageView?) {
        let imageName = localIconName(for: iconCode)
        imageView?.image = UIImage(named: imageName)
    }

    
    func fetchHourlyForecast(lat: Double, lon: Double) {
        let apiKey = APIkey.weatherAPIKey
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

                DispatchQueue.main.async {
                    let hourFormatter = DateFormatter()
                    hourFormatter.locale = Locale(identifier: "tr_TR")
                    hourFormatter.dateFormat = "HH:mm"

                    let calendar = Calendar.current
                    let now = Date()
                    var firstDateChecked = false

                    for (index, item) in first24.enumerated() {
                        guard index < self.hoursLabel.count else { continue }

                        let date = Date(timeIntervalSince1970: item.dt)
                        let hour = calendar.component(.hour, from: date)
                        let minute = calendar.component(.minute, from: date)
                        let isMidnight = hour == 0 && minute == 0

                        if !firstDateChecked {
                            self.hoursLabel[index].text = "Şimdi"
                            firstDateChecked = true
                        } else if isMidnight {
                            self.hoursLabel[index].text = "Yarın"
                        } else {
                            self.hoursLabel[index].text = hourFormatter.string(from: date)
                        }

                        let tempStr = "\(Int(item.main.temp))°C"
                        let popStr = "💧%\(Int(item.pop * 100))"
                        let fullText = "\(tempStr)\n\(popStr)"

                        let attr = NSMutableAttributedString(string: fullText)
                        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 18), range: (fullText as NSString).range(of: tempStr))
                        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: (fullText as NSString).range(of: popStr))

                        self.tempLabels[index].attributedText = attr

                        self.loadForecastIcon(named: item.weather.first?.icon ?? "", into: self.iconImageViews[index])
                    }

                    let maxRainChance = Int((first24.map { $0.pop }.max() ?? 0.0) * 100)
                    let totalRain = first24.map { $0.rain?.oneHour ?? 0.0 }.reduce(0.0, +)

                    self.rainpopLabel.text = "%\(maxRainChance)"
                    self.rainfallLabel.text = totalRain > 0 ? String(format: "%.1f mm", totalRain) : "Yok"
                }

            } catch {
                print("Çözümleme hatası: \(error)")
            }
        }.resume()
    }





}
