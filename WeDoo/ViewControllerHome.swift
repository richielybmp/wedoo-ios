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

    @IBOutlet weak var labelWelcome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userMail = Auth.auth().currentUser?.email
        labelWelcome.text = "Bem vindo, \(userMail ?? "< mail@mailo.com>")"

    }

    @objc func addToDoo() {
        print("xablau")
    }
    
    @IBAction func signOutClick(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
//            print("Log out com sucesso!")
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
        }
    }
}
