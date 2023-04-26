//
//  Course.swift
//  Networking
//
//  Created by Константин on 26.04.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import Foundation

struct Course: Codable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let numberOfLessons: Int?
    let numberOfTests: Int?
}
