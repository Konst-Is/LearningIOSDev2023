//
//  SelectTimeViewController.swift
//  FindNumber
//
//  Created by Константин on 11.01.2023.
//

import UIKit

class SelectTimeViewController: UIViewController {

    var data: [Int] = []

    @IBOutlet weak var tableView: UITableView! {
    didSet {
        tableView?.dataSource = self
        tableView?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
      //  tableView.reloadData() // Если у нас обновились данные и нужно обновить таблицу
    }
}

extension SelectTimeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count // Кол-во строк в таблице столько, сколько значений в data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) // Создаем ясейки по шаблону "timeCell"
        cell.textLabel?.text = String(data[indexPath.row]) // В нашем шаблоне ячейки есть титл, в него помещаем текст из массива data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Метод делегата. Что делать при выборе ячейки таблицы
        tableView.deselectRow(at: indexPath, animated: true) // Убирает подсвечивание строки после ее выбора с анимацией
        //UserDefaults.standard.setValue(data[indexPath.row], forKey: "timeForGame")
        Settings.shared.currentSettings.timeForGame = data[indexPath.row] // Новая настройка времени сохраняется в классе Settings в статическом свойстве shared (обращаемся к экз. Settings - синглтону, к его свойству currentSettings, а это экемпляр SettingsGame), при этом вызывается сеттер, и новая настройка записывается в UserDefaults
        navigationController?.popViewController(animated: true) // Возвращаемся на предыдущий экран настроек после того, как новая настройка сохранена
    }
}
