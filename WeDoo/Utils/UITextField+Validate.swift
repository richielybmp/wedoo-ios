//
//  UITextField+Validate.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 07/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    //Valida o self.text conforme o tipo de validator
    func validatedText(validatorType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validatorType)
        return try validator.validated(self.text!)
    }
}
