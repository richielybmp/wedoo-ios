//
//  AboutViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 20/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var ivRichiely: UIImageView!
    @IBOutlet weak var ivMateus: UIImageView!
    @IBOutlet weak var ivFilipe: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        adjustProfilePics()
    }
    
    func adjustProfilePics() {
        ivRichiely.layer.cornerRadius = ivRichiely.frame.size.width / 2
        ivRichiely.clipsToBounds = true
        
        ivMateus.layer.cornerRadius = ivMateus.frame.size.width / 2
        ivMateus.clipsToBounds = true
        
        ivFilipe.layer.cornerRadius = ivFilipe.frame.size.width / 2
        ivFilipe.clipsToBounds = true
        
    }
    
    @IBAction func openGitFilipe(_ sender: UIButton) {
        openUrl("mstedler")
    }
    
    @IBAction func openGitMateus(_ sender: UIButton) {
        openUrl("mstedler")
    }
    
    @IBAction func openGitRichiely(_ sender: UIButton) {
        openUrl("richielybmp")
    }
    
    func openUrl(_ user: String) {
        if let url = URL(string: "https://github.com/" + user){
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
