//
//  User.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/2/21.
//

import Foundation

// these are classes that are used to store data from backend

class User: Codable {
    let username: String
    let password: String
    let lat: Double
    let lon: Double
    let country_code: String
}

class UserResponse: Codable {
    let id: Int
    let username: String
    let lat: Double
    let lon: Double
    let times: [Int]
}

class createdUserResponse: Codable {
    let session_token: String
    let session_expiration: String
    let update_token: String
}

class Weather: Codable {
    let hourlyTemp: Double
    let chance: Double
    let message: String
    let rainAmount: Double
    let snowAmount: Double
    
    private enum CodingKeys : String, CodingKey {
        case hourlyTemp = "Hourly Temp"
        case chance = "Chance of Precipitation"
        case message = "Message"
        case rainAmount = "Rain Amount"
        case snowAmount = "Snow Amount"
    }
}
