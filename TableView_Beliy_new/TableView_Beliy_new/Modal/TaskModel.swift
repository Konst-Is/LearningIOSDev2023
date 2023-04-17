//
//  TaskModel.swift
//  TableView_Beliy_new
//
//  Created by Константин on 15.02.2023.
//

import Foundation

class Task: Codable {
    var title: String
    var description: String
    var id: String
    var isActive: Bool
    
    init(title: String, description: String, isActive: Bool) {
        self.title = title
        self.description = description
        self.isActive = isActive
        self.id = UUID().uuidString
    }
}

// MARK: - USERDEFAULTS -

extension Task {
    
    static let userDefaultsKey = "TasksKey"
    
    static func save(_ tasks: [Task]) {
        // Преобразуем массив задач в тип Data
        let data = try? JSONEncoder().encode(tasks)
        UserDefaults.standard.set(data, forKey: Task.userDefaultsKey)
    }
    
    static func loadTask() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: Task.userDefaultsKey),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            return tasks
        } else {
            return []
        }
    }
}


    

