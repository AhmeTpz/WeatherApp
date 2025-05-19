# iOS Hava Durumu Uygulaması ☀️🌧️

Swift ve UIKit kullanılarak geliştirilen bu mobil uygulama, kullanıcının konumuna göre anlık hava durumu, saatlik tahminler, 5 günlük ve 16 günlük hava tahminlerini kullanıcı dostu bir arayüzle sunar.

---

## 🔍 Genel Özellikler

- 📍 **Konum Tabanlı Hava Durumu:**  
  Uygulama, cihazın bulunduğu konumu `CLLocationManager` ile tespit eder ve buna göre hava durumu verilerini gösterir.

- 🌤️ **Anlık Hava Durumu Bilgileri:**  
  - Sıcaklık  
  - Hissedilen sıcaklık  
  - Açıklama (örneğin: parçalı bulutlu)  
  - Rüzgar hızı (km/s)  
  - Rüzgar yönü (örneğin: ↑ Kuzey)  
  - Yağış ihtimali

- 🕒 **Saatlik Tahmin (24 Saat):**  
  - İlk kutuda **"Şimdi"** yazısı bulunur.  
  - Gece 00:00 itibarıyla kutuda **"Yarın"** ifadesi gösterilir.  
  - Diğer saatler "01:00", "02:00" gibi devam eder.  
  - Sıcaklık altına 💧 ile yağmur olasılığı yüzdesi eklenir.

- 📅 **5 Günlük Hava Tahmini:**  
  - Günün adı ve tarihi (örneğin "Cuma\n24 May")  
  - Hava durumu ikonu  
  - Maksimum / minimum sıcaklık  
  - 💧 Yağış ihtimali ve toplam yağış miktarı  
  - Rüzgar hızı ve yönü

- 📆 **16 Günlük Geniş Vadeli Tahmin:**  
  - Ayrı bir sayfa üzerinden 16 gün boyunca günlük hava durumu bilgisi  
  - Her gün için tarih, sıcaklık, yağış ve rüzgar detayları  
  - 5 günlük bölüm ile benzer ama daha geniş aralık sunar

---

## ⚙️ Teknik Detaylar

- Swift dilinde UIKit mimarisi
- `URLSession` ile API çağrıları
- `Codable` ile JSON parse işlemi
- `CLLocationManager` ile konum verisi alma
- `DateFormatter` ile Türkçe tarih ve saat desteği
- `UIStackView`, `UILabel`, `UIImageView` ile dinamik arayüz bileşenleri
- Yağış oranı ve rüzgar yönü gibi bilgilerin emoji ve okunabilir metinlerle sunumu

---

## 🌐 Kullanılan API

- **[OpenWeatherMap API](https://openweathermap.org/api)**  
  Veriler `weather`, `forecast`, `forecast/hourly` ve `forecast/daily` endpoint'leri kullanılarak alınır.

- Uygulamada API key sabit olarak şu yapı ile çağrılır:
```swift
let apiKey = APIkey.weatherAPIKey
APIkey struct’ı ile kendi API anahtarınızı merkezi olarak yönetebilirsiniz.

🧭 Rüzgar Yönü Hesaplaması
Derece cinsinden gelen yön bilgileri, kullanıcıya şu şekilde sunulur:

Yön Açıklaması	Aralık (°)
↑ Kuzey	0°–22°, 338°–360°
↗ Kuzeydoğu	23°–67°
→ Doğu	68°–112°
↘ Güneydoğu	113°–157°
↓ Güney	158°–202°
↙ Güneybatı	203°–247°
← Batı	248°–292°
↖ Kuzeybatı	293°–337°

🔄 Gelecekte Planlanan Özellikler
🌙 Karanlık mod desteği

🗺️ Şehir arama ve favori konumlar

📊 Haftalık grafiksel analiz ekranı

🔔 Yağmur veya fırtına gibi durumlarda bildirim gönderimi

🌈 UV ve nem oranı gibi ek bilgiler

📂 Dosya Yapısı (Kısaca)
text
Kopyala
Düzenle
├── ViewController.swift          # Ana ekran (anlık, saatlik, 5 günlük)
├── SixteenViewController.swift  # 16 günlük ekran
├── WeatherResponse.swift        # Model dosyaları (dahil edilmedi)
├── APIkey.swift                 # API anahtar yönetimi
├── Assets.xcassets              # Hava durumu ikonları (clear_day, rain_night, vs.)
├── Main.storyboard              # Arayüz tasarımı
👨‍💻 Kurulum ve Kullanım
OpenWeatherMap üzerinden API anahtarınızı edinin.

APIkey.swift dosyasını oluşturun:

swift
Kopyala
Düzenle
struct APIkey {
    static let weatherAPIKey = "SENIN_API_KEY"
}
Xcode üzerinden uygulamayı çalıştırın (Gerçek cihaz konum verisi önerilir).

GitHub üzerinden projeyi clone ederek inceleyebilirsiniz.

📜 Lisans
Bu proje tamamen açık kaynaklıdır. Eğitim, portföy veya bireysel geliştirme amaçlı kullanılabilir.
Ticari projelerde kullanılmadan önce OpenWeatherMap’in kullanım koşulları kontrol edilmelidir.
