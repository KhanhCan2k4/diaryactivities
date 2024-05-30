//
//  ViewController.swift
//  DemoWeatherApp
//
//  Created by  User on 20.04.2024.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: FIELDS
    var lon = "";
    var lat =  "";
    let appid = "940a39e5fe69c802f9b6765b11a46304";
    var date = Date();
    
    var locationManager:CLLocationManager?;
    var location: CLLocation?;
    
    @IBOutlet var navbar: UINavigationItem!
    
    @IBOutlet weak var weatherType: UIImageView!
    
    @IBOutlet weak var nowDeg: UILabel!
    
    @IBOutlet weak var desc: UILabel!
    
    @IBOutlet weak var minMaxDeg: UILabel!
    
    @IBOutlet weak var feelLikeDeg: UILabel!
    
    @IBOutlet weak var wind: UILabel!
    
    @IBOutlet weak var humid: UILabel!
    
    @IBOutlet weak var uv: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    @IBOutlet weak var airPressure: UILabel!
    
    @IBAction func endView(_ sender: UIBarButtonItem) {
        dismiss(animated: true);
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.lat = "\(location.coordinate.latitude)"
        self.lon = "\(location.coordinate.longitude)"
        
        fetchWeatherAndUpdate();
        
        // Stop updating location to save battery life
        locationManager?.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navbar.title = "Không có quyền truy cập";
        
        self.nowDeg.text = "!  ";
        self.desc.text = "!";
        self.minMaxDeg.text = "Min: \("!"), Max: \("!")";
        self.feelLikeDeg.text = "!";
        self.wind.text = "!";
        self.humid.text = "!";
        self.uv.text = "!";
        self.visibility.text = "!";
        self.airPressure.text = "!";
        
        // Initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self;
        locationManager?.requestAlwaysAuthorization(); // Request authorization
        locationManager?.startUpdatingLocation();
    }
    
    // Define a function to fetch data from the API
    func fetchDataFromAPI(completion: @escaping (Result<Data, Error>) -> Void) {
        // Replace "your-api-url" with the actual URL of the API you want to fetch data from
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=\(appid)&lon=\(lon)&lat=\(lat)&date=\(Int(TimeInterval(date.timeIntervalSince1970)))") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        print("url: \(url)")
        
        // Create a URLSessionDataTask to fetch data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "Server Error", code: statusCode, userInfo: nil)))
                return
            }
            
            // Check if data is available
            guard let responseData = data else {
                completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                return
            }
            
            // Data fetched successfully
            completion(.success(responseData))
        }.resume() // Resume the task
    }
    
    func fetchWeatherAndUpdate() {
        
        if self.lon.isEmpty || self.lat.isEmpty {
            print("chua co dia chi");
            return;
        }
        self.navbar.title = "Tải";
        self.nowDeg.text = "Tải...";
        self.desc.text = "Tải...";
        self.minMaxDeg.text = "Min: \("Tải...") Max: \("Tải...")";
        self.feelLikeDeg.text = "Tải...";
        self.wind.text = "Tải...";
        self.humid.text = "Tải...";
        self.uv.text = "Tải...";
        self.visibility.text = "Tải...";
        self.airPressure.text = "Tải...";
        self.weatherType.image = UIImage(named: "sunny");
        
        fetchDataFromAPI { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    do {
                        let myWeather = try JSONDecoder().decode(MyWeatherAPI.self, from: data)
                        
                        if let main = myWeather.main {
                            if let temp = main.temp {
                                self.nowDeg.text = "\(round((temp - 273.15) * 10) / 10)°";
                            } else {
                                self.nowDeg.text = "~  ";
                            }
                            
                            if let min = main.temp_min,let max = main.temp_max {
                                self.minMaxDeg.text = "Min: \(round((min - 273.15) * 100) / 100)°, Max: \(round((max - 273.15) * 100) / 100)°";
                            } else {
                                self.minMaxDeg.text = "Min: ~, Max: ~";
                            }
                            
                            if let feels_like = main.feels_like {
                                self.feelLikeDeg.text = "\(round((feels_like - 273.15) * 100) / 100)°";
                            } else {
                                self.feelLikeDeg.text = "~";
                            }
                            
                            if let humidity = main.humidity {
                                self.humid.text = "\(humidity)%";
                            } else {
                                self.humid.text = "~";
                            }
                            
                            if let sea_level = main.sea_level {
                                self.uv.text = "\(sea_level)";
                            } else {
                                self.uv.text = "~";
                            }
                            
                            if let pressure = main.pressure {
                                self.airPressure.text = "\(pressure) hPa";
                            } else {
                                self.airPressure.text = "~";
                            }
                            
                        } else {
                            self.nowDeg.text = "~  ";
                            self.minMaxDeg.text = "Min: ~, Max: ~";
                            self.feelLikeDeg.text = "~";
                            self.humid.text = "~";
                            self.uv.text = "~";
                            self.airPressure.text = "~";
                        }
                        
                        if myWeather.weather.count > 0 {
                            self.desc.text = myWeather.weather[0].description;
                            self.weatherType.image = UIImage(named: myWeather.weather[0].main ?? "weather");
                        } else {
                            self.desc.text = "~";
                        }
                        
                        if let wind = myWeather.wind, let speed = wind.speed {
                            self.wind.text = "\(speed) m/s";
                        } else {
                            self.wind.text = "~";
                        }
                        
                        if let visibility = myWeather.visibility {
                            self.visibility.text = "\(visibility) m";
                        } else {
                            self.visibility.text = "~";
                        }
                        
                        if let city = myWeather.name {
                            self.navbar.title = "\(city) - \(self.date.formatted(date: .long, time: .omitted))";
                        } else {
                            self.navbar.title = "Không tìm thấy";
                        }
                        
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
                
            case .failure(let error):
                // Error occurred while fetching data
                print("Error fetching data: \(error)")
            }
        }
    }
}
