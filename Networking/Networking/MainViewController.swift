//
//  MainViewController.swift
//  Networking
//
//  Created by Константин on 29.04.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

enum Actions: String, CaseIterable {
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
}

class MainViewController: UICollectionViewController {
    
    private let reuseIdentifier = "Cell"
    private let getAndPostUrl = "https://jsonplaceholder.typicode.com/posts"
    private let uploadImage = "https: //api.imgur.com/3/image" // Изображение загружаем на сайт imgur.com, и там оно появится
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String? // Сюда сохраняем временную ссылку на файл при повторном запуске приложения
    
    override func viewDidLoad() { // Когда загрузка большого файла завершиться, автоматически запустится приложение и вызовется viewDidLoad()
        super.viewDidLoad()
        // Сохранить файл для дальнейшего использования
        registerForNotification()
        dataProvider.fileLocation = { (location) in // Обращаемся к захваченному значению свойства fileLocation
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        alert.view.addConstraint(height)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dataProvider.stopDownload()
        }
        
        
        alert.addAction(cancelAction)
        present(alert, animated: true) { [self] in
            let size = CGSize(width: 40, height: 40) // Размер ActivityIndicator
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2) // Координаты origin ActivityIndicator (вычисляем середину AlertController и от неё отступаем на половину ширины и высоты индикатора)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }

    // Заполняет кнопки текстами
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.item].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    // Обрабатывает нажатия на кнопки, запуская соответствующий метод.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.item]
        switch action {
        case .downloadImage: // Переход на новый экран и загрузка изображения
            performSegue(withIdentifier: "ShowImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: getAndPostUrl)
        case .post:
            NetworkManager.postRequest(url: getAndPostUrl)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .uploadImage: // Загрузка изображения из Assets на сервер imgur.com
            print("Upload Image")
            NetworkManager.uploadImage(url: uploadImage)
        case .downloadFile: // Загрузка большого файла с сервера в фоновом режиме
            showAlert()
            dataProvider.startDownload()
            
        }
    }
}

extension MainViewController {
    
    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { in
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent() // Создал экземпляр контента
        content.title = "Download complete!" // Заголовок
        content.body = "Your background transfer has completed. File path: \(filePath!)" // Тело контента
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // Триггер, по которому будет срабатывать уведомление, 3 сек с момента загрузки файла
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger) // Создаю запрос, присваиваю ему идентификатор, передаю контент и триггер
        UNUserNotificationCenter.current().add(request) // Запрос добавляю в центр нотификаций, и оно должно сработать
    }
}
