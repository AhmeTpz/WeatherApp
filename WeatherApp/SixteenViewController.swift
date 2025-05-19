import CoreLocation
import UIKit

class SixteenViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBAction func backbuttonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 16 gunluk
    
    @IBOutlet var day16Labels: [UILabel]!
    @IBOutlet var weathericon16ImageView: [UIImageView]!
    @IBOutlet var popfall16Labels: [UILabel]!
    @IBOutlet var maxmintemp16Labels: [UILabel]!
    @IBOutlet var windspeeddeg16Labels: [UILabel]!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude


            fetchSixteenDayForecast(lat: lat, lon: lon)
        }
    }

    
    func fetchSixteenDayForecast(lat: Double, lon: Double) {
        let apiKey = APIkey.weatherAPIKey
        let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&cnt=16&appid=\(apiKey)&units=metric&lang=tr"

        guard let url = URL(string: urlString) else {
            print("Geçersiz URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Hata oluştu: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Veri yok")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SixteenDayResponse.self, from: data)

                DispatchQueue.main.async {
                    for i in 0..<min(response.list.count, 16) {
                        let item = response.list[i]

                        // Tarih
                        let date = Date(timeIntervalSince1970: item.dt)
                        let dayFormatter = DateFormatter()
                        dayFormatter.locale = Locale(identifier: "tr_TR")
                        dayFormatter.dateFormat = "EEEE"
                        let dayName = dayFormatter.string(from: date).capitalized

                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "tr_TR")
                        dateFormatter.dateFormat = "d MMM"
                        let dateStr = dateFormatter.string(from: date)

                        self.day16Labels[i].text = "\(dayName)\n\(dateStr)"

                        // Ikon
                        self.loadForecastIcon(named: item.weather.first?.icon ?? "", into: self.weathericon16ImageView[i])

                        // Yağış oranı ve miktarı
                        let popPercent = Int(item.pop * 100)
                        let rainVolume = item.rain ?? 0
                        let rainText = rainVolume > 0 ? String(format: "%.1f mm", rainVolume) : "0 mm"
                        self.popfall16Labels[i].text = "💧%\(popPercent)\n\(rainText)"

                        // Sıcaklık
                        let maxTemp = Int(item.temp.max)
                        let minTemp = Int(item.temp.min)
                        self.maxmintemp16Labels[i].text = "\(maxTemp)° / \(minTemp)°"

                        // Rüzgar
                        let windText = String(format: "%.0f km/s\n%@", item.speed * 3.6, self.directionFrom(degree: item.deg))
                        self.windspeeddeg16Labels[i].text = windText
                    }
                }
            } catch {
                print("Çözümleme hatası: \(error)")
            }

        }.resume()
    }

    // Rüzgar yönü atamaları.
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

    
    func loadForecastIcon(named iconCode: String, into imageView: UIImageView?) {
        let imageName = localIconName(for: iconCode)
        imageView?.image = UIImage(named: imageName)
    }

    // Kendi ikonlarımızı tanımlıyoruz.
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
}
