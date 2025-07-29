//
//  NetworkManager.swift
//  MyToList
//
//  Created by Vladimir Eryshev on 21.07.2025.
//

import Foundation

protocol NetworkServiceProtocol: AnyObject {
    func fetchToDoItemList(completion: @escaping (Result<[ToDoDTO], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func fetchToDoItemList(completion: @escaping (Result<[ToDoDTO], Error>) -> Void) {
        DispatchQueue.global().async {
            guard let url = URL(string: Constants.apiBaseUrl) else { return }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(.failure(NetworkError.parsingError))
                    return
                }

                guard let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let todosResponse = try JSONDecoder().decode(ToDosResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(todosResponse.todos))
                    }
                } catch {
                    completion(.failure(NetworkError.noData))
                }
            }
            task.resume()
        }
    }
}



// MARK: - Errors
enum NetworkError: Error {
    case invalidResponse
    case noData
    case parsingError
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response received!"
        case .noData:
            return "No data!"
        case .parsingError:
            return "Response parsing error received!"
        }
    }
}

