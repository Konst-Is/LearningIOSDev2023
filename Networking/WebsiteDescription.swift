//
//  WebsiteDescription.swift
//  Networking
//
//  Created by Константин on 26.04.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import Foundation


// Эта структура для приложения не используется, создана для парсинга json с именем (3-й и 4-й вариант)
struct WebsiteDescription: Codable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
