//
//  TableViewController+NSFRCDelegate.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 07/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import Foundation
import CoreData

extension TableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvTableToDoo.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvTableToDoo.endUpdates()
        updateView()
    }
    
    //Toda vez que um object é inserido/deletado atualizar tvTableTodoo
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tvTableToDoo.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tvTableToDoo.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            print("ToDoo")
            //TODOO
        default:
            print("...")
        }
    }
}
