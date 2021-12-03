//
//  User.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/2/21.
//

import Foundation

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
