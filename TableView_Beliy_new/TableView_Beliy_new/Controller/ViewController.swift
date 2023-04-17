//
//  ViewController.swift
//  TableView_Beliy_new
//
//  Created by Константин on 15.02.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextField: UITextField!
    
    // При загрузке приложения загружаем задачи из UserDefaults
    private var tasks: [Task] = Task.loadTask() {
        didSet {
            Task.save(tasks)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Всегда отражает два экрана в Split режиме
        splitViewController?.preferredDisplayMode = .oneBesideSecondary
        
        myTableView.dataSource = self
        myTableView.delegate = self
        // Зарегистрировали xib за таблицей
        let nib = UINib(nibName: "XibTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "xibCellID")
        
        myTextField.delegate = self
    }
}

// MARK: - EXTENSION -

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "xibCellID", for: indexPath) as! XibTableViewCell
        cell.configure(tasks[indexPath.row])
        // Во время создания ячейки подписываемся на ее делегат.
        cell.delegate = self
        
       // Здесь используем другой прототип ячейки, созданный в сториборде
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellID", for: indexPath) as! MyTableViewCell
//        cell.configure(tasks[indexPath.row])
        //cell.myTitleLabel.text = tasks[indexPath.row].title
        return cell
    }
    // Метод  "передать стиль редактирования" - используем для удаления ячейки. Сначала нужно удалить задачу из массива задач и только потом ячейку. Иначе crash.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // При выборе ячейки создаутся новый detail вьюконтроллер, на котором отразится описание задачи.
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController {
            vc.task = tasks[indexPath.row]
        splitViewController?.showDetailViewController(vc, sender: nil)
        }
        
        // В выбранной ячейке ставим галочку или убираем ее.
//        let cell = tableView.cellForRow(at: indexPath)
//        if cell?.accessoryType == .checkmark {
//            cell?.accessoryType = .none
//        } else {
//            cell?.accessoryType = .checkmark
//        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let task = Task(title: textField.text ?? "", description: "New Task", isActive: true)
        self.tasks.append(task)
        myTableView.reloadData()
        textField.text = ""
        return true
    }
}

// При изменении свитча в ячейке, она сообщит об этом и во вью контроллере изменим проперти задачи по индексу ячейки
extension ViewController: XibTableViewCellDelegate {
    func didChangeActivity(_ cell: XibTableViewCell, isActive: Bool) {
        if let indexPath = myTableView.indexPath(for: cell) {
            tasks[indexPath.row].isActive = isActive
            Task.save(tasks)
        }
    }
    
    
}
