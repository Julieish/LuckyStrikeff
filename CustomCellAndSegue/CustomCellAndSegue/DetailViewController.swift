//
//  DetailViewController.swift
//  CustomCellAndSegue
//
//  Created by 수현 on 2021/10/25.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var albumLbl: UILabel!
    
    var name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let name = self.name {
            albumLbl.text = name
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
