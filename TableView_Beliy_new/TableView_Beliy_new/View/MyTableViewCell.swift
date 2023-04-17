//
//  MyTableViewCell.swift
//  TableView_Beliy_new
//
//  Created by Константин on 15.02.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myTitleLabel: UILabel!
    
    func configure(_ task: Task) {
        myTitleLabel.text = task.title
    }
}
