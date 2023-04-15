//
//  ViewController.swift
//  URLSessionExample
//
//  Created by Константин on 15.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let image = "https://picsum.photos/300/400"
    //"https://i.pinimg.com/originals/ea/ca/19/eaca19ef903445578899fc1b2cbc0910.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getImageButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: image) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
}

