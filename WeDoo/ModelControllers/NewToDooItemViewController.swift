//
//  NewToDooItemViewController.swift
//  WeDoo
//
//  Created by Richiely Paiva on 12/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class NewToDooItemViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{

    @IBOutlet weak var vrImageViewToDooItem: UIImageView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    
    var managedObjectContext: NSManagedObjectContext?
    var toDooSelecionado: ToDoo?
    var toDooItemSelecionado: ToDooItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if toDooItemSelecionado != nil {
            tfTitle.text = toDooItemSelecionado?.titulo
            tfDescription.text = toDooItemSelecionado?.descricao
            //vrImageViewToDooItem.image = toDooItemSelecionado?.imagem
            let titulo = toDooItemSelecionado?.titulo
            self.title = "Editar \(titulo ?? "ToDoo Item")"
        }
        hideKeyboardWhenTappedAround()
    }
    
    //tap recognizer para esconder o teclado
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
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
        
        //PORQUE EU ESTOU RODANDO NO EMULADOR
        photo.sourceType = .savedPhotosAlbum
        
        photo.delegate = self
        
        self.present(photo, animated: true, completion: nil)
    }
    
    
    @IBAction func saveAndPop(_ sender: UIBarButtonItem) {
        if validate() {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func validate() -> Bool {
        guard let managedObjectContext = managedObjectContext else { return false }
        var result = true
        
        do {
            let title = try tfTitle.validatedText(validatorType: .title)
            let description = tfDescription.text
            let itemImage = vrImageViewToDooItem.image
            
            let toDooItem = ToDooItem(context: managedObjectContext)
            guard let dataImage = itemImage?.jpegData(compressionQuality: 1) else { return false }
            //toDooItem.imagem = NSData(data: dataImage) as Data
            toDooItem.titulo = title
            toDooItem.descricao = description
            toDooItem.status = false
            
            if toDooItemSelecionado != nil {
                //let item = toDooSelecionado?.itens?.filtered(using: NSPredicate(format: "id = %@", toDooItemSelecionado!.id!))
                toDooItemSelecionado?.setValue(toDooItem.titulo, forKey: "titulo")
                toDooItemSelecionado?.setValue(toDooItem.descricao, forKey: "descricao")
                //toDooItemSelecionado?.setValue(toDooItem.imagem, forKey: "imagem")
            }
            else {
                toDooItem.status = false
                toDooItem.id = UUID().uuidString
                toDooItem.createdate = Date()
                
                toDooSelecionado?.addToItens(toDooItem)
            }
            try managedObjectContext.save()
        }
        catch {
            result = false
            if error is ValidationError {
                showAlert(for: (error as! ValidationError).message)
            } else {
                showAlert(for: error.localizedDescription)
            }
        }
        
        return result
    }
}
