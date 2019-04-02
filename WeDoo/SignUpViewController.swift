//
//  SignUpViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 02/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeBackButtonPressed))
        self.navigationItem.title = "Criar conta"
    }
    
    @objc func closeBackButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

}
