//
//  ForgotPasswordViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 21/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Redefinir senha"
    }
    @IBAction func actionSendRecoverEmail(_ sender: UIButton) {
        if tfEmail.text != "" {
            Auth.auth().sendPasswordReset(withEmail: tfEmail.text!) {(error) in
                
                if error == nil {
                    self.showMessage(msg: "O email para redefinir sua senha foi enviado")
                }
                else {
                    self.showMessage(msg: error!.localizedDescription)
                }
            }
        }
    }
    
    func showMessage(msg: String) {
        let alertController = UIAlertController(title: "Redefinir senha", message: msg, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
