//
//  UIViewController+Alert.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 07/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //Mostra um Alert com uma mensagem
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
