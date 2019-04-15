//
//  SignUpViewController.swift
//  WeDoo
//
//  Created by Richiely Paiva on 02/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeBackButtonPressed))
        self.navigationItem.title = "Criar conta"
        
        criaSpinner()
    }
    
    
    @IBAction func handleSignUpClicked(_ sender: UIButton) {
        let email = tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let senha = tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        showSpinner(show:true)
        Auth.auth().createUser(withEmail: email!, password: senha!) { (authResult, error) in
            if error == nil {
                Auth.auth().signIn(withEmail: email!, password: senha!, completion: { (user, error) in
                    if error == nil {
                        let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "TabHomeScreen") as! UITabBarController
                        self.present(homeVc, animated: true, completion: nil)                        
                    }
                    else {
                        let alert = UIAlertController(title: "Sign In Failed", message: error!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.showSpinner(show:false)
                })
            }
            else {
                let alert = UIAlertController(title: "Sign In Failed", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
                self.showSpinner(show:false)
            }
        }
    }
    
    @IBAction func handleSignInClicked(_ sender: UIButton) {
        let signInVc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let navigationVc = UINavigationController(rootViewController: signInVc)
        present(navigationVc, animated: true, completion: nil)
    }
    
    private func showSpinner(show: Bool){
        if (show){
            spinner.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else{
            spinner.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    private func criaSpinner(){
        spinner.center = self.view.center
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(spinner)
    }
    
    @objc func closeBackButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

}
