//
//  ViewControllerHome.swift
//  WeDoo
//
//  Created by Richiely Paiva on 01/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class ViewControllerHome: UIViewController {

    @IBOutlet weak var labelWelcome: UILabel!
    @IBOutlet weak var vrProfileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userMail = Auth.auth().currentUser?.email
        
        if let userPhoto = Auth.auth().currentUser?.photoURL
        {
            setProfileImage(userPhoto)
        }
        labelWelcome.text = "Bem vindo, \(userMail ?? "< mail@mailo.com>")"
    }

    func setProfileImage (_ imageURL: URL){
        vrProfileImage.layer.cornerRadius = vrProfileImage.frame.size.width / 2
        vrProfileImage.clipsToBounds = true
        vrProfileImage.af_setImage(withURL: imageURL)
    }
    
    @IBAction func signOutClick(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
