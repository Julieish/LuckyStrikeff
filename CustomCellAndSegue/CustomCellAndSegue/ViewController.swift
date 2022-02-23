//
//  ViewController.swift
//  CustomCellAndSegue
//
//  Created by 수현 on 2021/10/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let data = ["Angel Baby", "Bloom", "for him", "Youth", "Easy", "Lucky Strike", "Strawberries & Cigarettes", "Dance To This", "Fools"]
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int {
                vc?.name = data[index]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? customCell else {
            return UITableViewCell()
        }
        cell.albumImg.image = UIImage(named: "\(data[indexPath.row]).png")
        cell.albumLbl.text = data[indexPath.row]
        
        return cell
    }

    
}

class customCell: UITableViewCell {
    @IBOutlet var albumImg: UIImageView!
    @IBOutlet var albumLbl: UILabel!
}

