//
//  SettingsTableViewController.swift
//  FindNumber
//
//  Created by Константин on 11.01.2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var switchTimer: UISwitch!
    @IBOutlet weak var timeGameLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings() // Каждый раз перед появлением этого экрана обновляем положение свитча (таймер) и лейбл со временем игры
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController {
                vc.data = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120]
            }
        default: break
        }
    }
    
    func loadSettings() { // Устанавливает свитч согласно настройкам и выводит в лейбл время игры из текущих настроек, т.е. обновляем экран
        switchTimer.isOn = Settings.shared.currentSettings.timerState
        timeGameLabel.text = "\(Settings.shared.currentSettings.timeForGame) сек"
    }
    
    @IBAction func changeTimer(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn // Изменение свитча (свойство таймер включен?) вызовет экземпляр класса Settings с настройками и изменит его св-во currentSettings. Сработает сеттер и новый экз. структуры с настройками запишется в UserDefaults.
    }
    
    @IBAction func resetSettings(_ sender: UIButton) {
        Settings.shared.resetSettings()  // Вызываем метод resetSettings() класса Settings, он меняет настройки на по умолчанию
        loadSettings()  // Обновляем экран
    }
    
    
}

