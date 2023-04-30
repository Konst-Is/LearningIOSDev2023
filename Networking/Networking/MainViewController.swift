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
    
    let actions = Actions.allCases
    
    override func viewDidLoad() {
       super.viewDidLoad()

       self.collectionView.delegate = self
       self.collectionView.dataSource = self
       self.collectionView.allowsSelection = true
       //self.collectionView.allowsMultipleSelection = true

    }
    
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
        print(indexPath.item)
        let action = actions[indexPath.item]
        print(action.rawValue)
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: "https://jsonplaceholder.typicode.com/posts")
        case .post:
            NetworkManager.postRequest(url: "https://jsonplaceholder.typicode.com/posts")
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage:
            print("Upload Image")
        }
    }
}
