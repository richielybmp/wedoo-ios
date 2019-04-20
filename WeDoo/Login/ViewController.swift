//
//  ViewController.swift
//  WeDoo
//
//  Created by Richiely Paiva on 01/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        criaSpinner()
        checkIfUserIsSignedIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        showSpinner(show:true)
        if let error = error {
            showAlert("didSignInFor Failed", "OK", error: error)
            self.showSpinner(show:false)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                self.showAlert("SignIn with credential Failed", "OK", error: error)
                self.showSpinner(show:false)
                return
            }
            self.showSpinner(show:false)
            return
        }
    }
    
    @IBAction func openSignUpScreen(_ sender: UIButton) {
        let signUpVc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let navigationVc = UINavigationController(rootViewController: signUpVc)
        present(navigationVc, animated: true, completion: nil)
    }
    
    @IBAction func openSignInScreen(_ sender: UIButton) {
        let signInVc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let navigationVc = UINavigationController(rootViewController: signInVc)
        present(navigationVc, animated: true, completion: nil)
    }
    
    private func checkIfUserIsSignedIn() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                // user is signed in
                // go to feature controller
                self.abrirHome()
            }
        }
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
    
    private func abrirHome(){
        let signInVc = storyboard?.instantiateViewController(withIdentifier: "TabHomeScreen") as! UITabBarController
        present(signInVc, animated: true, completion: nil)
    }
    
    private func showAlert(_ acTitle: String, _ aaTitle: String, error: Error){
        let alert = UIAlertController(title: acTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: aaTitle, style: .default))
        present(alert, animated: true, completion: nil)
    }
}
