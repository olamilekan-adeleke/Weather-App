import CoreLocation
import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var windSpeedText: UILabel!
    @IBOutlet var humidityText: UILabel!
    @IBOutlet var feelsLikeText: UILabel!
    @IBOutlet var summaryText: UILabel!

    var weatherManager: WeatherManager = .init()
    let locationManager: CLLocationManager = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        searchTextField.delegate = self
        weatherManager.delegate = self
    }

    @IBAction func GetCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

// MARK: UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        loadWeather()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Text Field Stop Editing")
        loadWeather()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a location"
            return false
        }
    }

    func loadWeather() {
        if let query: String = searchTextField.text {
            weatherManager.getWeather(query)
        }
    }
}

// MARK: WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didSuccessWeatherUpdate(_ weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.main.getTemp()
            self.conditionImageView.image = UIImage(named: weatherData.weather[0].getWeatherImage())
            self.cityLabel.text = "\(weatherData.name)"
            self.windSpeedText.text = String(weatherData.wind.speed)
            self.humidityText.text = String(weatherData.main.humidity)
            self.feelsLikeText.text = String(weatherData.main.feelsLike)
            self.summaryText.text = weatherData.weather[0].description.capitalized
        }
    }

    func didErrorWeatherUpdate(_ error: Error) {
        print("Error: \(error)")
    }
}

// MARK: CLLocationManger

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Got Loaction")
        if let last = locations.last {
            let lat = Float(last.coordinate.latitude)
            let lng = Float(last.coordinate.longitude)

            weatherManager.getWeather(lat: lat, lng: lng)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Loaction Error: \(error)")
    }
}
