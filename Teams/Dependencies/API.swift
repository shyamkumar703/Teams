//
//  API.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//

import Foundation

protocol API {
    func call<ResponseType: Codable>(
        urlPath: String,
        responseType: ResponseType.Type,
        storageKey: StorageKey?,
        completion: @escaping (Result<ResponseType, TeamsError>) -> Void
    )
    
    func call<ResponseElement: Codable>(
        urlPath: String,
        responseType: Array<ResponseElement>.Type,
        storageKey: StorageKey?,
        completion: @escaping (Result<Array<ResponseElement>, TeamsError>) -> Void
    )
}

enum TeamsError: Error {
    case missingData
    case decodingError
    case networkError(Error)
}

class APIManager: API {
    private var dependencies: HasStorage
    
    init(dependencies: HasStorage) {
        self.dependencies = dependencies
    }
    
    func call<ResponseType: Codable>(
        urlPath: String,
        responseType: ResponseType.Type,
        storageKey: StorageKey?,
        completion: @escaping (Result<ResponseType, TeamsError>) -> Void
    ) {
        guard let url = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else {
                guard let data = data else {
                    completion(.failure(.missingData))
                    return
                }
                if let response = try? JSONDecoder().decode(ResponseType.self, from: data) {
                    completion(.success(response))
                    self?.dependencies.storage.save(response, with: storageKey)
                    return
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
    
    func call<ResponseElement: Codable>(
        urlPath: String,
        responseType: Array<ResponseElement>.Type,
        storageKey: StorageKey?,
        completion: @escaping (Result<Array<ResponseElement>, TeamsError>) -> Void
    ) {
        guard let url = URL(string: urlPath) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else {
                guard let data = data else {
                    completion(.failure(.missingData))
                    return
                }
                if let response = try? JSONDecoder().decode(responseType, from: data) {
                    completion(.success(response))
                    self?.dependencies.storage.save(response, with: storageKey)
                    return
                } else {
                    completion(.failure(.decodingError))
                }
            }
        }
        task.resume()
    }
}
