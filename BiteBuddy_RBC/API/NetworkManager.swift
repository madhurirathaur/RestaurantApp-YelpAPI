//
//  NetworkManager.swift
//  BiteBuddy_RBC
//
//  Created by MVijay on 31/10/23.
//

import Foundation

protocol NetworkHandler {
    associatedtype errorType: Error
    func sendRequest<T: Decodable>(expectedTypeObject: T.Type, _ requestContainer: NetworkRequestor, completion: @escaping (ServiceResult<T, errorType>) -> Void)
}


public class NetworkManager : NetworkHandler {

    typealias errorType = CommunicationError
        
    static let shared = NetworkManager()
    private init() {}
    
    func sendRequest<T: Decodable>(expectedTypeObject: T.Type, _ requestContainer: NetworkRequestor, completion: @escaping (ServiceResult<T, errorType>) -> Void) {
        guard let request = requestContainer.request else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.customError(error.localizedDescription)))
                return
            }
            if let data = data {
                do {
                    let dataObject = try JSONDecoder().decode(expectedTypeObject, from: data)
                    completion(.success(dataObject))
                } catch {
                    completion(.failure(.jsonParsingFailure(error.localizedDescription)))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}

enum ServiceResult<T, U> where U: Error {
    case success(T)
    case failure(U)
}

enum CommunicationError: Error {
    case invalidURL
    case invalidData
    case jsonParsingFailure(String)
    case customError(String)
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidData: return "Invalid Data"
        case .jsonParsingFailure(let parsingError): return "JSON Parsing Failure \(parsingError)"
        case .customError(let errorMessage): return errorMessage
        }
    }
}
