//
//  MyTableViewCell.swift
//  Networking_Beliy
//
//  Created by Константин on 15.04.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func configure(_ post: Post) {
        myLabel.text = post.title
        bodyLabel.text = post.body
    }



}
