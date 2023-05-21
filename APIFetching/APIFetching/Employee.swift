//
//  Employee.swift
//  APIFetching
//
//  Created by Константин on 20.05.2023.
//

import Foundation

struct Employee: Codable {
    let id: Int
    let employee_name: String
    let employee_salary: Int
}

struct Query: Decodable {
    let status: String
    let data: [Employee]
}


extension Employee {
    // Для того, чтобы можно было проверить дизайн и отобразить на экране одного сотрудника
    static let example = Employee(id: 1, employee_name: "Tim Cook", employee_salary: 30000)
}
