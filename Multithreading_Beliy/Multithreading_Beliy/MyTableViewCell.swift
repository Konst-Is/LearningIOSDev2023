//
//  MyTableViewCell.swift
//  Multithreading_Beliy
//
//  Created by Константин on 09.03.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    func configure(path: String) {
        if let url = URL(string: path),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
              photoImageView.image = image
        }
    }
}
