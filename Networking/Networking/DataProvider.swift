//
//  DataProvider.swift
//  Networking
//
//  Created by Константин on 04.05.2023.
//  Copyright © 2023 Alexey Efimov. All rights reserved.
//

import UIKit

// Класс для скачивания большого файла с сервера в фоновом режиме. Сначала в настройках проекта в Capabilities нужно добавить Background Modes
class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask! // Будем передавать в это свойство параметры конфигурации и использовать этот объект для настройки сессии
    
    var fileLocation: ((URL) -> ())? // Клоужер, в который мы передадим ссылку (URL) на наш временный файл при завершении загрузки
    var onProgress: ((Double) -> ())? // Отвечает за отображение хода выполнения загрузки, клоужер с Double
    
    private lazy var bgSession: URLSession = { // Здесь будем сохранять экз. сессии с настройками конфигурации
        let config = URLSessionConfiguration.background(withIdentifier: "ru.swiftbook.Networking") // передаем сюда bundle identifier нашего приложения
        config.isDiscretionary = true // Могут ли фоновые задачи быть запланированы по усмотрению системы для оптимальной производительности. Для передачи больших данных рекомендуется установить true
        config.sessionSendsLaunchEvents = true // По завершению загрузки данных наше приложение автоматически запуститься в фоновом режиме и вызовет метод делегата urlSessionDidFinishEvents(ForBackgroundURLSession) из класса AppDelegate
        return URLSession(configuration: config, delegate: self, delegateQueue: nil) // Т.к. мы назначили наш класс делегатом, нужно подписать его под протокол(см. ниже)
    }()
    
    func startDownload() { // Метод начала загрузки
        if let url = URL(string: "https://speedtest.selectel.ru/100MB") { // Ссылка, откуда мы будем скачивать файл
            downloadTask = bgSession.downloadTask(with: url) // Здесь будет создан экземпляр URLSession
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3) // Загрузка начнется не ранее, чем через 3 сек после создания задачи
            downloadTask.countOfBytesClientExpectsToSend = 512 // Указываю верхнюю границу числа байтов
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024 // 100MB - наиболее вероятная верхняя граница размера скачиваемого файла
            downloadTask.resume()
        }
    }
    
    func stopDownload() { // Остановить загрузку данных
        downloadTask.cancel()
    }
    
}

extension DataProvider: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) { // Этот метод удет вызываться по завершении всех фоновых задач, помещенных в очередь с нашим идентификатором приложения
        DispatchQueue.main.async { // Т.к. bgSessionCompletionHandler относится к UIKit, весь блок помещаем в главную очередь.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let completionHandler = appDelegate.bgSessionCompletionHandler else { return } // Мы создаём константу completionHandler, в которую передаём захваченное значение идентификатора нашей сессии из класса AppDelegate
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler() // Вызываем completionHandler(), чтобы уведомить систему о том, что загрузка завершена
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { // Этот метод запустится при выходе из фонового режима. При этом в AppDelegate должен вызваться метод, который будет перехватывать идентификатор нашей сессии. См. AppDelegate
        print("Did finish downloading: \(location.absoluteString)") // Распечатаем ссылку на временную директорию, куда сохраняется скачанный файл
        
        DispatchQueue.main.async {
            self.fileLocation?(location) // Передадим в клоужер ссылку (путь) к скачанному файлу
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) { // Отображение хода выполнения загрузки
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) // Количество полученных байт делим на количество байт, которые мы должны получить
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress) // Передаём в клоужер величину зарузки
        }
    }
}
