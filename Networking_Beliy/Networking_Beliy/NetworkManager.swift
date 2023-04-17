//
//  NetworkManager.swift
//  Networking_Beliy
//
//  Created by Константин on 15.04.2023.
//

import Foundation

class NetworkingManager {
    // Для хранения названий запросов
    enum HTTPMethod: String {
        case POST
        case PUT
        case GET
        case DELETE
    }
    // Для хранения конечной части адреса запроса
    enum APIs: String {
        case posts
        case users
        case comments
    }
    
    private let baseURL = "https://jsonplaceholder.typicode.com/"
    // Метод скачивает с сервера все посты
    func getAllPosts(_ completionHandler: @escaping ([Post]) -> Void) { // Клоужер сохранит посты в переменную posts и выведет в label сообщение, что посты скачаны
        if let url = URL(string: baseURL + APIs.posts.rawValue) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error in request")
                } else {
                    if let response = response as? HTTPURLResponse,
                       response.statusCode == 200,
                       let data = data,
                       let posts = try? JSONDecoder().decode([Post].self, from: data) {
                        completionHandler(posts) // Если удалось скачать и декодировать посты, вызываем клоужер и передаем в него посты
                    }
                }
            }.resume()
        }
    }
    // Метод размещает на сервер пост
    func postCreatePost(_ post: Post, completionHandler: @escaping (Post) -> Void) {
        guard let url = URL(string: baseURL + APIs.posts.rawValue),
              let data = try? JSONEncoder().encode(post) else { return } // Кодируем в байты пост
        // Создаем и конфигурируем request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.POST.rawValue // или "POST"
        request.httpBody = data // В тело запроса передается кодированный пост
        // Установить два хедера: длина сообщения и формат сообщения
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Создаем сессию с реквестом
        URLSession.shared.dataTask(with: request) {  (data, response, error) in
            if error != nil {
                print("error")
            } else if let response = response as? HTTPURLResponse,
                      response.statusCode == 201,
                      let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data), // Преобразуем биты в json просто посмотреть, что там
                      let respPost = try? JSONDecoder().decode(Post.self, from: data)  {
                print(json)
                completionHandler(respPost) // Клоужер покажет alert
            }
        }.resume()
    }
    // Метод скачивает все посты одного пользователя с данным userId
    func getPostBy(userId: Int, completionHandler: @escaping ([Post]) -> Void) {
        guard let url = URL(string: baseURL + APIs.posts.rawValue) else { return }
        // Безопасное формирование query запроса
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "userId", value: "\(userId)")]
        guard let queryURL = components?.url else { return }
        
        URLSession.shared.dataTask(with: queryURL) { (data, response, error) in
            if error != nil {
                print("error")
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let posts = try? JSONDecoder().decode([Post].self, from: data) {
                completionHandler(posts)
             }
        }.resume()
    }
}
