//
//  AppManagedContext.swift
//  WeDoo
//
//  Created by Gean Delon on 16/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AppManagedContext
{
    static func ManagedContext() -> NSManagedObjectContext {
        var contexto: NSManagedObjectContext {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return delegate.persistentContainer.viewContext
        }
        
        contexto.undoManager = UndoManager()
       
        return contexto
    }
}
