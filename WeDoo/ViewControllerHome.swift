//
//  ViewControllerHome.swift
//  WeDoo
//
//  Created by Gean Delon on 01/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerHome: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signOutClick(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Log out com sucesso!")
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
