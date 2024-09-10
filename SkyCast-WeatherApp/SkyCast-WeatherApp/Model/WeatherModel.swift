//
//  WeatherModel.swift
//  SkyCast-WeatherApp
//
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let timestamp: Int
    let timezoneOffset: Int
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    var cityDate: String {
        let currentDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let adjustedDate = currentDate.addingTimeInterval(TimeInterval(timezoneOffset))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateString = dateFormatter.string(from: adjustedDate)
        return "\(dateString)"
    }
}
