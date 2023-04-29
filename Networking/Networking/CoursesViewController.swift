//
//  CoursesViewController.swift
//  Networking
//
//  Created by Alexey Efimov on 06.09.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var courses = [Course]()
    private var courseName: String? // Выбранный пользователем курс
    private var courseURL: String? // Ссылка на выбранный курс
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func fetchData() {
        //let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_course" // По этому адресу запрашиваем json c одним словарем, по второму - массив словарей, третий json с именем и описанием сайта, четвертый - битый json, аналогичный 3-му варианту
        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses" // Скачиваем массив словарей
        //let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
        //let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                // Это св-во позволяет изменять поля на другие названия, чем в json
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //let course = try JSONDecoder().decode(Course.self, from: data) // Для первого варианта
                self.courses = try JSONDecoder().decode([Course].self, from: data)
                //let websiteDescription = try JSONDecoder().decode(WebsiteDescription.self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print("Error serialization json", error)
            }
        }.resume()
    }
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.courseNameLabel.text = course.name
        
        if let numberOfLessons = course.numberOfLessons {
            cell.numberOfLessons.text = "Number of lessons: \(numberOfLessons)"
        }
        if let numberOfTests = course.numberOfTests {
            cell.numberOfTests.text = "Number of tests: \(numberOfTests)"
        }
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: course.imageUrl) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
    }
    // Подготовка к переходу, передаем название курса и ссылку на курс при переходе
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedCourse = courseName
        if let url = courseURL {
            webViewController.courseURL = url
        }
    }
}



// MARK: Table View Data Source

extension CoursesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }
}

// MARK: Table View Delegate

extension CoursesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Фиксируем ячейку, по которой тапает пользователь и осуществляем переход
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseURL = course.link
        courseName = course.name
        performSegue(withIdentifier: "Description", sender: self)
    }
}

