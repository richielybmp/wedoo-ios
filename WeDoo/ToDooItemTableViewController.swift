//
//  ToDooItemTableViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 12/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit

class ToDooItemTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var vrEmptyToDooItemListLabel: UILabel!
    
    @IBOutlet weak var tableViewToDooItem: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView();
    }

    //Mostra label se nao houver ToDoos
    func updateView(){
        var hasToDoos = false
        
//        if let toDoos = fetechedResultsController.fetchedObjects {
//            hasToDoos = toDoos.count > 0
//        }
//
        tableViewToDooItem.isHidden = !hasToDoos
        vrEmptyToDooItemListLabel.isHidden = hasToDoos
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
