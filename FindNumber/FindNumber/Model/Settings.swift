//
//  Settings.swift
//  FindNumber
//
//  Created by Константин on 13.01.2023.
//

import Foundation

enum KeyUserDefaults { // Enum предназначен только для хранения ключей, чтобы не ошибится в их написании
    static let settingsGame = "settingsGame"
    static let recordGame = "recordGame"
}

struct SettingsGame: Codable {  // Структура для хранения настроек, д.б. подписана на два протокола для кодирования
    var timerState: Bool
    var timeForGame: Int
}

class Settings {
    static var shared = Settings()  // Синглтон
    private let defaultSettings = SettingsGame(timerState: true, timeForGame: 40) // Дефолтные настройки
    var currentSettings: SettingsGame { // Вычисляемое св-во. Сохраняет настройки в UserDefaults при  их изменении (сеттер), для этого надо нажать на ячейку таблицы, а также считывает их оттуда
        get {
            if let data = UserDefaults.standard.object(forKey: KeyUserDefaults.settingsGame) as? Data {
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data) // Если в UserDefaults есть даные по ключу, то декодируем их
            } else { // иначе, если удается закодировать defaultSettings, то возвращаем их. И здесь настройки по умолчанию помещаем в UserDefaults
                if let data = try? PropertyListEncoder().encode(defaultSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeyUserDefaults.settingsGame)
                }
                return defaultSettings  // Если нет настроек из UserDefaults, возвращаем дефолтные
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeyUserDefaults.settingsGame)
            }
        }
    }
    
    func resetSettings() {  // Перезаписывает текущие настройки на дефолтные
        currentSettings = defaultSettings
    }
}
