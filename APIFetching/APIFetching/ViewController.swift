//
//  ViewController.swift
//  APIFetching
//
//  Created by Константин on 20.05.2023.
//

import UIKit

class ViewController: UIViewController {

    private var employees = [Employee]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.fetchEmployees { result in
            switch result {
            case .success(let decodeEmployees):
                print("success")
                self.employees = decodeEmployees
            case .failure(let networkError):
                print("failure: \(networkError)")
            }
        }
    }


}

