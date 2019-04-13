//
//  NewToDooViewController.swift
//  WeDoo
//
//  Created by Gean Delon on 06/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class NewToDooViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var pvType: UIPickerView!
    
    var types :  [String] = ["Tarefa", "Compra"]
    
    var managedObjectContext: NSManagedObjectContext?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Novo ToDoo"
        dpEndDate.minimumDate = Date()
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

    @IBAction func saveAndPop(_ sender: Any) {
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
            let type = types[pvType.selectedRow(inComponent: 0)]
            let encerramento = dpEndDate.date
            
            let toDoo = ToDoo(context: managedObjectContext)
            toDoo.titulo = title
            toDoo.descricao = description
            toDoo.tipo = type
            toDoo.encerramento = encerramento
            toDoo.id = UUID().uuidString
            
            try managedObjectContext.save()
            
        } catch (let error) {
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
