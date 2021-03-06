//
//  WeatherViewModel.swift
//  Weatherity
//
//  Created by Harsh on 29/01/2022.
//

import Foundation


class WeatherViewModel {
    
    var weatherModel: WeatherModel!
    var arrDailyWeather: [DailyWeather]?
    
    var timer = Timer()
    
    typealias dailyWeatherCallBack = (_ success: NetworkManager.statusCode, _ message: String) -> Void
    
    func getDailyWeatherAPI(response: @escaping dailyWeatherCallBack) {
        
        ///TODO: Added JSON in bundle to avoid API call while testing (As open API calls are limited 😋)
//        if let path = Bundle.main.path(forResource: "weather", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                self.weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
//                self.arrDailyWeather = self.weatherModel.dailyWeathers ?? []
//                response(NetworkManager.statusCode.success, "")
//                return
//              } catch {
//
//              }
//        }

        var strURL = WebServices.URLs.onecall.value
        strURL += "&lat=25.2048"
        strURL += "&lon=55.2708"
        strURL += "&exclude=current,minutely,hourly,alerts"
        strURL += "&units=metric"
        strURL += "&appid=" + Constants.openWeatherMapAPIKey

        HPapiRequestWrapper.requestGETURL(strURL, dictHeader: nil, success: { responceData in

            if let data = responceData {
                do {
                    self.weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                    if let message = self.weatherModel.message {
                        response(NetworkManager.statusCode.fail, message)
                    }
                    else {
                        self.arrDailyWeather = self.weatherModel.dailyWeathers ?? []
                        response(NetworkManager.statusCode.success, "")
                    }
                    return
                }
                catch let error {
                    response(NetworkManager.statusCode.fail, error.localizedDescription)
                    return
                }
            }
            else {
                response(NetworkManager.statusCode.fail, NetworkManager.somethingWentWrong)
            }
        }) { error in
            response(NetworkManager.statusCode.fail, error.localizedDescription)
        }
    }
    
    func getTempUnit() -> String {
        switch HPUserDefaults.shared.temperatureUnit {
        case TemperatureUnits.fahrenheit.rawValue:
            return StringBase.kFahrenheit
        default:
            return StringBase.kCelcius
        }
    }
    
    func getCalculatedTemperature(_ celsius: Double) -> String {
        switch HPUserDefaults.shared.temperatureUnit {
        case TemperatureUnits.fahrenheit.rawValue:
            return String(format: "%.2f", celsius.toFahrenheit())
        default:
            return String(format: "%.2f", celsius)
        }
    }
}
