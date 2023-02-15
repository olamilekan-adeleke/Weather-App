//
//  WeatherManager.swift
//  Clima
//
//  Created by Enigma Kod on 13/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didSuccessWeatherUpdate(_ weatherData: WeatherModel)

    func didErrorWeatherUpdate(_ error: Error)
}

struct WeatherManager {
    private let baseUrl: String = "https://api.openweathermap.org/data/2.5/weather?appid=05df6dfc5e34fe40c31566a7b3f4d9cf&units=metric"

    var delegate: WeatherManagerDelegate?

    func getWeather(_ query: String) {
        let url = "\(baseUrl)&q=\(query)"
        fetchWeatherByQuery(with: url)
    }

    func getWeather(lat: Float, lng: Float) {
        let url = "\(baseUrl)&lat=\(lat)&lon=\(lng)"
        fetchWeatherByQuery(with: url)
    }

    private func fetchWeatherByQuery(with urlLink: String) {
        if let url = URL(string: urlLink) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    self.delegate?.didErrorWeatherUpdate(error!)
                    return
                }

                if let safeData = data {
                    if let weatherModel = parseJson(safeData) {
                        self.delegate?.didSuccessWeatherUpdate(weatherModel)
                    }
                }
            }

            task.resume()
        }
    }

    private func parseJson(_ data: Data) -> WeatherModel? {
        do {
            let decoder = JSONDecoder()
            let weatherData: WeatherModel = try decoder.decode(WeatherModel.self, from: data)
            return weatherData

        } catch {
            return nil
        }
    }
}
