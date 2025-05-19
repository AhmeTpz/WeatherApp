# iOS Hava Durumu Uygulaması ☀️🌧️

Swift ve UIKit kullanılarak geliştirilen bu mobil uygulama, kullanıcının konumuna göre anlık hava durumu, saatlik tahminler, 5 günlük ve 16 günlük hava tahminlerini kullanıcı dostu bir arayüzle sunar.

---

## 🔍 Genel Özellikler

- 📍 **Konum Tabanlı Hava Durumu:**  
  Cihazın bulunduğu konum tespit edilerek ilgili hava durumu verileri çekilir.

- 🌤️ **Anlık Hava Durumu:**  
  - Sıcaklık  
  - Hissedilen sıcaklık  
  - Açıklama  
  - Rüzgar hızı ve yönü  
  - Yağış ihtimali

- 🕒 **Saatlik Tahmin (24 Saat):**  
  - İlk kutuda “Şimdi”  
  - Gece 00:00 olduğunda “Yarın”  
  - Her saat için sıcaklık + 💧 yağış yüzdesi

- 📅 **5 Günlük Tahmin:**  
  - Gün adı + tarih  
  - Hava durumu ikonu  
  - Maksimum / minimum sıcaklık  
  - 💧 Yağış oranı ve mm cinsinden miktar  
  - Rüzgar yönü ve hızı

- 📆 **16 Günlük Tahmin (Ayrı Sayfa):**  
  - Her gün için genişletilmiş veri  
  - Günlük ikon, sıcaklık, yağış ve rüzgar bilgileri

---

## ⚙️ Teknik Detaylar

- Swift (UIKit) ile native geliştirme  
- `CLLocationManager` ile konum alma  
- `URLSession` ve `Codable` ile API veri çekimi  
- `DateFormatter` ile yerel tarih biçimlendirme  
- Emoji ve stil destekli UI detayları  
- Ayrı controller’larla modüler yapı

---

## 🌐 Kullanılan API

- **[OpenWeatherMap API](https://openweathermap.org/api)**  
  Kullanılan endpointler:
  - `/weather`
  - `/forecast`
  - `/forecast/hourly`
  - `/forecast/daily`

```swift
let apiKey = APIkey.weatherAPIKey
```swift

🌬️ Rüzgar Yönü Tablosu
Yön Açıklaması	Aralık (°)
↑ Kuzey	0–22, 338–360
↗ Kuzeydoğu	23–67
→ Doğu	68–112
↘ Güneydoğu	113–157
↓ Güney	158–202
↙ Güneybatı	203–247
← Batı	248–292
↖ Kuzeybatı	293–337

📂 Proje Yapısı
text
Kopyala
Düzenle
├── ViewController.swift          # Ana ekran (anlık, saatlik, 5 günlük)
├── SixteenViewController.swift  # 16 günlük ekran
├── WeatherResponse.swift        # Model dosyaları (dahil değil)
├── APIkey.swift                 # API anahtar yönetimi
├── Assets.xcassets              # Özel ikonlar
├── Main.storyboard              # UI tasarımı
🚀 Kurulum
OpenWeatherMap üzerinden API anahtarınızı alın.

APIkey.swift dosyasını oluşturun:

swift
Kopyala
Düzenle
struct APIkey {
    static let weatherAPIKey = "SENIN_API_KEY"
}
🔮 Geliştirme Planları
🌙 Karanlık mod

🗺️ Şehir arama ve favoriler

📊 Grafikli özet ekranı

🔔 Yağmur/fırtına uyarıları

🌡️ UV/nem oranı bilgisi

📄 Lisans
Bu proje açık kaynaklıdır. Eğitim ve kişisel kullanım için uygundur.
Ticari projelerde kullanmadan önce OpenWeatherMap lisans şartları incelenmelidir.
