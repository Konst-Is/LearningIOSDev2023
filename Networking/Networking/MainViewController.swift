//
//  MainViewController.swift
//  Networking
//
//  Created by Константин on 29.04.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
}

class MainViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    private let getAndPostUrl = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImage = "https: //api.imgur.com/3/image" // Изображение загружаем на сайт imgur.com, и там оно появится
    let actions = Actions.allCases
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.item].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: getAndPostUrl)
        case .post:
            NetworkManager.postRequest(url: getAndPostUrl)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            NetworkManager.uploadImage(url: uploadImage)
        }
    }
}
