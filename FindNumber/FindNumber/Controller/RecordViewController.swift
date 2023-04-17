//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Константин on 18.01.2023.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Отражает информацию, полученную из UserDefaults в label
        let record = UserDefaults.standard.integer(forKey: KeyUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = "Ваш рекорд: \(record) сек."
        } else {
            recordLabel.text = "Рекорд пока не установлен"
        }
    }

    @IBAction func closeVC(_ sender: UIBarButtonItem) { // При нажатии на кнопку закрывает модальный вью контроллер
        dismiss(animated: true, completion: nil)
    }
}
