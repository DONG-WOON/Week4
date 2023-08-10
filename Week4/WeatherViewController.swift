//
//  WeatherViewController.swift
//  Week4
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Alamofire
import SwiftyJSON

final class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest(at: "44.34", longitude: "10.99")
    }
    
    private func callRequest(at latitude: String, longitude: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(APIKEY.weatherKey)&lang=kr"
        
        AF.request(url).validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let weatherData):
                let id = weatherData.weather[0].id
                let humidity = weatherData.main.humidity
                
                self.humidityLabel.text = "\(humidity)"
                switch id {
                case 800:
                    self.weatherLabel.text = ""
                case 801..<900:
                    self.weatherLabel.text = ""
                default:
                    return
                }
            case.failure(let error):
                print(error)
            }
        }
    }
}
