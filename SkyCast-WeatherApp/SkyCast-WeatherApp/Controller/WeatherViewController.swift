//
//  ViewController.swift
//  SkyCast-WeatherApp
// 
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    //MARK: - IB Outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    //MARK: - IB Actions
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//MARK: - Textfield Delegate methods
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // to dismiss the keyboard
        cityTextField.endEditing(true)
        return true
    }
    
    // to check if user is typing if not set placeholder text
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type city name"
            return false
        }
    }
    
    // get the value enetered by the user
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let enteredCity = textField.text {
            weatherManager.fetchWeather(cityName: enteredCity)
        }
        textField.text = ""
    }
    
}

//MARK: - WeatherManager Delegate methods
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ manager: WeatherManager, weatherData: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weatherData.cityName
            self.temperatureLabel.text = weatherData.temperatureString
            self.weatherConditionLabel.text = weatherData.description
            self.dateLabel.text = weatherData.cityDate
            self.weatherConditionImageView.image = UIImage(systemName: weatherData.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Error while fetching the weather data", error)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while fetching the location data", error)
    }
}
