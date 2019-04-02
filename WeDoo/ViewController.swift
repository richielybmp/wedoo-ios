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
            print("Ocorreu um erro ao tentar autenticar -  Level 1")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Ocorreu um erro ao tentar autenticar - Level 2")
                self.showSpinner(show:false)
                return
            }
            print("Autenticação feita com sucesso!!! \(authResult?.user.displayName)")
            //self.abrirHome()
            self.showSpinner(show:false)
            return
        }
    }
    
    @IBAction func openSignUpScreen(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVc = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let navigationVc = UINavigationController(rootViewController: signUpVc)
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
    
}


// todo:
// fazer login with email e senha
// fazer navigation controller
// fazer profile
