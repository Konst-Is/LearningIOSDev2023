//
//  Post.swift
//  Networking_Beliy
//
//  Created by Константин on 09.04.2023.
//

import Foundation

class Post: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
    
    init(userId: Int, title: String, body: String) {
        self.userId = userId
        self.id = 0 // id присвоит сервер, это порядковый номер поста на сервере, будет 101
        self.title = title
        self.body = body
    }
}
