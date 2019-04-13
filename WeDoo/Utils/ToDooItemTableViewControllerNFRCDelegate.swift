//
//  ToDooItemTableViewControllerNFRCDelegate.swift
//  WeDoo
//
//  Created by Gean Delon on 13/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
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
            print("ToDooItem")
        //TODOO
        default:
            print("...")
        }
    }
}

