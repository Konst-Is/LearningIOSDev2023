//
//  ImageProperties.swift
//  Networking
//
//  Created by Константин on 04.05.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

struct ImageProperties { // Эта структура данных соответствует API сайта imgur. Для загрузки изображения мы должны передать экземпляр этой структуры, имеющий свойства: ключ "image" и картинку в формате Data
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) { // В инициализатор передаем ключ (беру с сайта imgur) и картинку в формате pmg или jpeq.
        self.key = key
        guard let data = image.pngData() else { return nil } // Метод преобразует png в Data. Т.к. преобразование может вернуть nil, инициализатор делаем опциональным
        self.data = data
    }
}
