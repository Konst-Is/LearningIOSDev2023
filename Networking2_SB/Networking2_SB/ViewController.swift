//
//  ViewController.swift
//  Networking2_SB
//
//  Created by Константин on 23.04.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRequest(_ sender: UIButton) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let response = response,
            let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            } catch {
                print(error)
            }
            
            

        }.resume()
    }
    
    @IBAction func postRequest(_ sender: UIButton) {
    }
    
}

