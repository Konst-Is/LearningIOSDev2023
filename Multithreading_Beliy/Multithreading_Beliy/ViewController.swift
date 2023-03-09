//
//  ViewController.swift
//  Multithreading_Beliy
//
//  Created by Константин on 09.03.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            let nib = UINib(nibName: "MyTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "MyCellID")
        }
    }
    
    var images: [String] = ["https://hamleys.ru/upload/iblock/6af/6af32d026088c08e86bd875b5e3e7d0c.jpg",
        "https://a.allegroimg.com/original/11181d/f88eb52d423488cef0524a4f2725",
        "https://detki-online.com/upload/iblock/055/055198885f93b7e614c6e2568a2f683b.jpg",
        "https://pickimage.ru/wp-content/uploads/images/detskie/newyeargifts/novogodnipodarki13.jpg",
        "https://rebenkoved.ru/wp-content/uploads/2016/11/Igrushki-dlya-detej.jpg",
        "https://multi-boom.ru/upload/iblock/7da/7da7ebfa4b197fae4868c1fca106f91e.jpeg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.sync {
//            print("Hello")
//        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellID", for: indexPath) as! MyTableViewCell
        cell.configure(path: images[indexPath.row])
        return cell
    }
    
    
}

