//
//  XibTableViewCell.swift
//  TableView_Beliy_new
//
//  Created by Константин on 15.02.2023.
//

import UIKit

protocol XibTableViewCellDelegate: AnyObject {
    func didChangeActivity(_ cell: XibTableViewCell, isActive: Bool)
}

class XibTableViewCell: UITableViewCell {

    @IBOutlet weak var xibTitleLabel: UILabel!
    @IBOutlet weak var xibDescriptionLabel: UILabel!
    @IBOutlet weak var activeSwitch: UISwitch!
    
    weak var delegate: XibTableViewCellDelegate?
    
    func configure(_ task: Task) {
        xibTitleLabel.text = task.title
        xibDescriptionLabel.text = task.description
        activeSwitch.isOn = task.isActive
    }
    
    @IBAction func didChangeActivity(_ sender: UISwitch) {
        delegate?.didChangeActivity(self, isActive: sender.isOn)
    }
    
}
