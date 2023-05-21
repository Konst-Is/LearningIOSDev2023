//
//  NetworkManager.swift
//  APIFetching
//
//  Created by Константин on 21.05.2023.
//

import Foundation

enum Link { // Для хранения url
    case employees
    
    var url: URL {
        switch self {
        case .employees:
            return URL(string: "https://dummy.restapiexample.com/api/v1/employees")!
        }
    }
}

enum NetworkError: Error {
    case noData
    case tooManyRequesr // Сервер перегружен и не отвечает
    case decodingError
}

final class NetworkManager: ObservableObject { // Поддерживает ObservableObject из фреймворка Combine, т.к. у него будут published параметры
    static let shared = NetworkManager()
    init() {} // Д.т.ч. невозможно было снаружи создать экземпляр класса, это синглтон
    
    func fetchEmployees(completion: @escaping (Result<[Employee], NetworkError>) -> Void) {
        //employees = [Employee.example] // Для проверки отображения на экране
        let fetchRequest = URLRequest(url: Link.employees.url)
        URLSession.shared.dataTask(with: fetchRequest) { data, response, error in
            if error != nil {
                print("Error in session")
                completion(.failure(.noData))
            } else {
                let httpResponse = response as? HTTPURLResponse // Кастим, чтобы получить доступ к statusCode
                print("Status code: \(httpResponse?.statusCode ?? 0)")
                
                if httpResponse?.statusCode == 429 {
                    completion(.failure(.tooManyRequesr))
                } else {
                    guard let safeData = data else { return }
                    do {
                        let decodedQuery = try JSONDecoder().decode(Query.self, from: safeData)
                        completion(.success(decodedQuery.data))
                    } catch let decodeError {
                        print("Decoding error: \(decodeError.localizedDescription)")
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.resume()
    }
    
}
