//
//  SignInViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 02/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    let mainSb = UIStoryboard(name: "Main", bundle: nil)
    
     var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeBackButtonPressed))
        self.navigationItem.title = "Entrar"
        criaSpinner()
    }
    
    @IBAction func handleSignInClicked(_ sender: UIButton) {
        
        let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let senha = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        showSpinner(show: true)
        Auth.auth().signIn(withEmail: email!, password: senha!, completion: { (user, error) in
            if error == nil {
                let homeVc = self.mainSb.instantiateViewController(withIdentifier: "HomeScreen") as! ViewControllerHome
                self.present(homeVc, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Sign In Failed", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            self.showSpinner(show: false)
        })
    }
    
    private func showSpinner(show: Bool){
        if (show){
            self.spinner.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else{
            self.spinner.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func criaSpinner(){
        self.spinner.center = self.view.center
        self.spinner.hidesWhenStopped = true
        self.spinner.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(spinner)
    }
    
    @objc func closeBackButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }

}
