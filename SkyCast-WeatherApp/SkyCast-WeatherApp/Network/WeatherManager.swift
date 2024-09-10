//
//  NetworkManager.swift
//  SkyCast-WeatherApp
//
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ manager: WeatherManager, weatherData: WeatherModel)
    func didFailWithError(error: Error)
}

class WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    let baseURL = Constants.apiKey
    
    // This function makes an api call & fetches the weather data using the city name
    func fetchWeather(cityName: String) {
        let urlString = "\(baseURL)&q=\(cityName)"
        performNetworkCall(with: urlString)
    }
    
    // This function makes an api call & fetches the weather data using location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        performNetworkCall(with: urlString)
    }
    
    func performNetworkCall(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            guard let fetchedData = data else { return }
            guard let weatherData = self.parseJSON(data: fetchedData) else { return }
            self.delegate?.didUpdateWeather(self, weatherData: weatherData)
        }
        task.resume()
    }
    
    // This function is used to parse the JSON into weather model
    func parseJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            let timestamp = decodedData.dt
            let timezoneOffset = decodedData.timezone
            let description = decodedData.weather[0].description
            let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature, description: description, timestamp: timestamp, timezoneOffset: timezoneOffset)
            return weatherModel
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
