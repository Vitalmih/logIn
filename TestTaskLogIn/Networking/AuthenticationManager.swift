//
//  AuthenticationManager.swift
//  TestTaskLogIn
//
//  Created by Виталий on 21.01.2021.
//

import Foundation

protocol AuthenticationManagerProtocol {
    var dataTask: URLSessionDataTask? { get }
    var delegate: AuthenticationManagerDelegate? { get set }
    
    func logIn(with email: String, password: String)
}

protocol AuthenticationManagerDelegate {
    func didFailWithError(error: Error)
    func didGetUser(_ user: UserDataModel)
}

enum HTTPmethods: String {
    case POST
    case PUT
    case GET
    case DELETE
}

enum Parametrs: String {
    case email
    case password
    case projectId = "project_id"
}

class AuthenticationManager: AuthenticationManagerProtocol {
    
    var dataTask: URLSessionDataTask?
    var delegate: AuthenticationManagerDelegate?
    
    private let requestLink = "https://api-qa.mvpnow.io/v1/sessions"
    private let projectId = "58b3193b-9f15-4715-a1e3-2e88e375f62b"
    
    func logIn(with email: String, password: String) {
        performRequest(urlString: requestLink, email: email, password: password)
    }
    
    private func performRequest(urlString: String, email: String, password: String) {
        guard let url = URL(string: requestLink) else { return }
        let parametrs = [Parametrs.email.rawValue: email, Parametrs.password.rawValue: password, Parametrs.projectId.rawValue: projectId]
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPmethods.POST.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.delegate?.didFailWithError(error: error)
                }
            }
            
            if let safeData = data {
                self.parseJSON(data: safeData)
            }
        }
        dataTask?.resume()
    }
    
    private func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UserDataModel.self, from: data)
            let keyChain = KeychainSwift()
            let token = decodedData.token
            keyChain.set(token, forKey: "userToken")
            DispatchQueue.main.async {
                self.delegate?.didGetUser(decodedData)
            }
        } catch {
            DispatchQueue.main.async {
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
}
