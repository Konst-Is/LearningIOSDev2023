//
//  DetailViewController.swift
//  TableView_Beliy_new
//
//  Created by Константин on 17.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let task = self.task {
            titleLabel.text = task.title
            descriptionLabel.text = task.description
        } else {
            titleLabel.text = "Please select task!"
            descriptionLabel.text = ""
        }
    }
    


}
