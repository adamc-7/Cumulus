//
//  NetworkManager.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/2/21.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let endpoint = "https://cumulusrain.herokuapp.com"
    

    static func getAllUsers(completion: @escaping ([UserResponse]) -> Void) {
        AF.request("\(endpoint)/api/users", method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                print(String(data: data, encoding: .utf8)!)
                if let userResponse = try? jsonDecoder.decode([UserResponse].self, from: data) {
                    let users = userResponse
                    print(users.count)
                    completion(users)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func createUser(username: String, password: String, lat: Double, lon: Double, country_code: String, completion: @escaping (createdUserResponse) -> Void) {
        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "lat": lat,
            "lon": lon,
            "country_code": country_code
        ]

        AF.request("\(endpoint)/api/users/", method: .post, parameters: parameters,  encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(createdUserResponse.self, from: data) {
                    let user = userResponse
                    completion(user)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func loginUser(username: String, password: String, completion: @escaping (createdUserResponse) -> Void) {
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        AF.request("\(endpoint)/api/login/", method: .post, parameters: parameters,  encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let userResponse = try? jsonDecoder.decode(createdUserResponse.self, from: data) {
                    let user = userResponse
                    completion(user)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getWeather(token: String, completion: @escaping (Weather) -> Void) {
        let headers: HTTPHeaders = ["Authorization": token, "Content-Type": "application/json"]
        AF.request("\(endpoint)/api/users/weather/current",  method: .get, headers: headers).validate().responseData {
            response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let weatherResponse = try? jsonDecoder.decode(Weather.self, from: data) {
                    print("hello")
                    let weather = weatherResponse
                    completion(weather)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
