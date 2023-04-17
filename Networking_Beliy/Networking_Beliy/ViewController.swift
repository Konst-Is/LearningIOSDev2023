//
//  ViewController.swift
//  Networking_Beliy
//
//  Created by Константин on 09.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var networkingManager = NetworkingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }


    @IBAction func downloadPostsDidTap(_ sender: UIButton) {
        // Чтобы не создавать еще одну кнопку я привязал к этой кномпке два метода, один закомментировал
        //networkingManager.getAllPosts { [weak self] (posts) in
        networkingManager.getPostBy(userId: 3) { [weak self] (posts) in
            DispatchQueue.main.async {
                self?.posts = posts
                self?.titleLabel.text = "Posts has been downloaded"
            }
        }
    }

    @IBAction func createPost(_ sender: UIButton) {
        // Для учебных задач пост создаю вручную
        let post = Post(userId: 1, title: "My post", body: "Text of the post")
        networkingManager.postCreatePost(post) { serverPost in
            post.id = serverPost.id // Обновим идентификатор нашему посту на тот, что пришел с сервера
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Greate!", message: "Your post has been created!", preferredStyle: .alert)
                self.present(alert, animated: true)
                // Через 3 сек. алерт исчезнет
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    alert.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else { fatalError() }
        cell.configure(posts[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}


