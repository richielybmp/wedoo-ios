//
//  ViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 01/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    var spinner:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //let mainSb = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //GIDSignIn.sharedInstance().signIn()
        criaSpinner()
        checkIfUserIsSignedIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        showSpinner(show:true)
        if let error = error {
            showAlert("didSignInFor Failed", "OK", error: error)
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
            //print("Autenticação feita com sucesso!!! \(authResult?.user.displayName)")
            //self.abrirHome()
            self.showSpinner(show:false)
            return
        }
    }
    
    @IBAction func openSignUpScreen(_ sender: UIButton) {
        let signUpVc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let navigationVc = UINavigationController(rootViewController: signUpVc)
        present(navigationVc, animated: true, completion: nil)
        //navigationVc.pushViewController(signUpVc, animated: true)
    }
    
    @IBAction func openSignInScreen(_ sender: UIButton) {
        let signInVc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let navigationVc = UINavigationController(rootViewController: signInVc)
        present(navigationVc, animated: true, completion: nil)
        //navigationVc.pushViewController(signInVc, animated: true)
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
    
    private func abrirHome(){
        self.performSegue(withIdentifier: "showHomeSegue", sender: self)
    }
    
    private func showAlert(_ acTitle: String, _ aaTitle: String, error: Error){
        let alert = UIAlertController(title: acTitle, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: aaTitle, style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}


// todo:
// fazer login with email e senha
// fazer navigation controller
// fazer profile
