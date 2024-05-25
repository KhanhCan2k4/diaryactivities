//
//  OpenWeatherAPI.swift
//  DemoWeatherApp
//
//  Created by MAC on 22/5/24.
//

import Foundation


struct WeatherAPI : Decodable {
    var main:String?;
    var description:String?;
    
    enum CodingKeys: String, CodingKey {
        case main = "main"
        case description = "description"
    }
}


struct WindAPI : Decodable {
    var speed:Double?;
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
}


struct MainAPI : Decodable {
    var temp:Double?;
    var feels_like:Double?;
    var temp_min:Double?;
    var temp_max:Double?;
    var pressure:Int?;
    var sea_level:Int?;
    var humidity:Int?;
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feels_like = "feels_like"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case pressure = "pressure"
        case sea_level = "sea_level"
        case humidity = "humidity"
    }
}

struct MyWeatherAPI: Decodable {
    var main:MainAPI?;
    var wind:WindAPI?;
    var weather:[WeatherAPI] = [WeatherAPI]();
    var visibility:Int?;
    var name:String?;
    
    enum CodingKeys: String, CodingKey {
        case visibility
        case main = "main"
        case wind = "wind"
        case weather = "weather"
        case name = "name"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.visibility = try container.decode(Int.self, forKey: .visibility);
        self.wind = try container.decode(WindAPI.self, forKey: .wind);
        self.weather = try container.decode([WeatherAPI].self, forKey: .weather);
        self.name = try container.decode(String.self, forKey: .name);
        self.main = try container.decode(MainAPI.self, forKey: .main);
    }
}

