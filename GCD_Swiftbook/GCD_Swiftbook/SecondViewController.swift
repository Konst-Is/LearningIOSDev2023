//
//  SecondViewController.swift
//  GCD_Swiftbook
//
//  Created by Константин on 11.03.2023.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            activityIndicator.stopAnimating()
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
// Алерт контроллер должен появиться через 5 сек. после загрузки фото и открытия второго экрана.
        delay(5) {
            self.loginAlert()
        }
    }
// Задержка выполнения кода через asyncAfter. Параметры: время в сек. и клоужер
    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
// Всплывающее окно, которое будет появляться через некоторое время после показа картинки и требовать залогиниться
    fileprivate func loginAlert() {
        let ac = UIAlertController(title: "Are you registered?", message: "Enter your login and password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        ac.addTextField { (usernameTF) in
            usernameTF.placeholder = "Enter login"
        }
        ac.addTextField { (userPasswordTF) in
            userPasswordTF.placeholder = "Enter password"
            userPasswordTF.isSecureTextEntry = true
        }
        
        self.present(ac, animated: true, completion: nil)
    }
 
// Метод, который скачивает картинку из интернета и отображает ее на экране. Загрузка картинки происходит в глобальной очереди, а установка в главной.
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://avatars.mds.yandex.net/get-pdb/2945457/50fcfc55-bbc2-40b5-9c5e-a4d309301c54/s1200?webp=false")
        activityIndicator.startAnimating()
        let queue = DispatchQueue.global(qos: .utility)
        queue.async { [weak self] in
            if let url = self?.imageURL,
               let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: imageData)
                }
            }
        }
    }
}
