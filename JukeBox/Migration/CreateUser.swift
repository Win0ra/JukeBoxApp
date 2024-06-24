//
//  CreateUser.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 24/06/2024.
//

import Fluent

func createUser(user: UserSignUp, completion: @escaping (Bool, Error?) -> Void) {
    guard let url = URL(string: "http://localhost:8080/signup") else {
        completion(false, nil)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(user)
        request.httpBody = jsonData
    } catch {
        completion(false, error)
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(false, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(false, nil)
            return
        }
        
        completion(true, nil)
    }
    task.resume()
}
