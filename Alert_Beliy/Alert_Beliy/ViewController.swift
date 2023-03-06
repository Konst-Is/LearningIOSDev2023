//
//  ViewController.swift
//  Alert_Beliy
//
//  Created by Константин on 20.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.     
    }

    @IBAction func showAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "Photo Access", message: "Doyou alow to use your photos?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showActionSheet(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Choose film", preferredStyle: .actionSheet)
        
        let handler : (UIAlertAction) -> Void = { action in
            print(sender.titleLabel?.text ?? "Oops!")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: handler)
        alert.addAction(cancelAction)
        let film1 = UIAlertAction(title: "SpiderMan", style: .default, handler: handler)
        alert.addAction(film1)
        let film2 = UIAlertAction(title: "Alladin", style: .default, handler: handler)
        alert.addAction(film2)
        let film3 = UIAlertAction(title: "Mask", style: .default, handler: handler)
        alert.addAction(film3)
        let film4 = UIAlertAction(title: "Meet Joe Black", style: .default, handler: handler)
        alert.addAction(film4)
        present(alert, animated: true, completion: nil)
    }
    
}

