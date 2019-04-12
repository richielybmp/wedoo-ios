//
//  NewToDooItemViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 12/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit

class NewToDooItemViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{

    @IBOutlet weak var vrImageViewToDooItem: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        //BUSCA OS DADOS DA IMAGEM NO DICIONARIO
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

        //SETA O IMAGEVIEW PARA A IMAGEM ESCOLHIDA
        vrImageViewToDooItem.image = photo

        //GARANTE A SAIDA DO PICKER DA TELA
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlePickImageClicked(_ sender: UIButton) {
        let photo = UIImagePickerController()
        
        //PORQUE EU ESTOU RODANDO NO EMULADORRRRRRRRRR 😱
        photo.sourceType = .savedPhotosAlbum
        
        photo.delegate = self
        
        self.present(photo, animated: true, completion: nil)
    }
    
}
