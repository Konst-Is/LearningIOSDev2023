//
//  Network Manager.swift
//  Networking
//
//  Created by Константин on 29.04.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func getRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            //print(data)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("GET", json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func postRequest(url: String) {
        
        guard let url = URL(string: url) else { return }
        
        let userData = ["Course": "Networking", "Lesson": "GET and POST"]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("POST", json)
            } catch {
                print(error)
            }
        } .resume()
    }
    
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        } .resume()
    }
    
    static func fetchData(url: String, completion: @escaping (_ courses: [Course]) -> ()) {
        //let url = "https://swiftbook.ru//wp-content/uploads/api/api_course" // По этому адресу запрашиваем json c одним словарем, по второму - массив словарей, третий json с именем и описанием сайта, четвертый - битый json, аналогичный 3-му варианту
        //let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses" // Скачиваем массив словарей
        //let url = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
        //let url = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                // Это св-во позволяет изменять поля на другие названия, чем в json
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //let course = try JSONDecoder().decode(Course.self, from: data) // Для первого варианта
                let courses = try JSONDecoder().decode([Course].self, from: data)
                //let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                completion(courses)
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    static func uploadImage(url: String) {
        let image = UIImage(named: "Piramida2")!
        let httpHeaders = ["Authorization": "Client ID 1bd22b9ce396a4c"] // Взято из API сайта imgur
        guard let imageProperties = ImageProperties(withImage: image, forKey: "image") else { return }
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = httpHeaders
        request.httpBody = imageProperties.data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data)
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
}
