//
//  TableViewController.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 06/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tvTableToDoo: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvTableToDoo.dequeueReusableCell(withIdentifier: "toDooCell") as! ToDooCell
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Do any additional setup after loading the view.
    }
    
    @objc func addToDoo() {
        print("xablau")
    }

    @IBOutlet weak var vrAddToDoo: UIBarButtonItem!
}
