//
//  MyTableViewCell.swift
//  Multithreading_Beliy
//
//  Created by Константин on 09.03.2023.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var path: String?
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    func configure(path: String) {
        self.path = path
        indicator.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Downloading images from the Internet.
            if let url = URL(string: path),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data),
            // Checking that the image has not changed during the time it has been uploaded.
            path == self?.path {
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                    self?.indicator.stopAnimating()
                }
            }
        }
    }
}
