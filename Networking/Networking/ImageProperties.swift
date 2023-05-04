//
//  ImageProperties.swift
//  Networking
//
//  Created by Константин on 04.05.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
