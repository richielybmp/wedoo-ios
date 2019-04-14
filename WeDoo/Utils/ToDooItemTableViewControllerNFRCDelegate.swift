//
//  ToDooItemTableViewControllerNFRCDelegate.swift
//  WeDoo
//
//  Created by Richiely Paiva on 13/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import Foundation
import CoreData

extension ToDooItemTableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvToDooItem.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvToDooItem.endUpdates()
        updateView()
    }
    
    //Toda vez que um object é inserido/deletado atualizar tvTableTodoo
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tvToDooItem.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tvToDooItem.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tvToDooItem.cellForRow(at: indexPath) as! ToDooItemCell
                configureCell(cell, at: indexPath)
            }
        default:
            print("...")
        }
    }
}

