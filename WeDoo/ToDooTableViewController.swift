//
//  TableViewController.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 06/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let segueAddToDooViewController = "SegueAddToDooViewController"
    private let segueEditToDoo = "SegueEditToDoo"
    
    private let segueOpenToDooItemList = "SegueOpenToDooItemList"
    
    @IBOutlet weak var tvTableToDoo: UITableView!

    @IBOutlet weak var lblMessage: UILabel!
    
    private var toDooAux: ToDoo?
    
    var contexto: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.persistentContainer.viewContext
    }
    
    fileprivate lazy var fetechedResultsController : NSFetchedResultsController<ToDoo> = {
        //Cria um Fetch Request
        let fetchRequest: NSFetchRequest<ToDoo> = ToDoo.fetchRequest()
        
        //Configura Fetch Request para ordenar pela data de encerramento
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "encerramento", ascending: true)]
        
        //Cria o Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        //Metodos implementados em Utils/TableViewController+...
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let toDoos = fetechedResultsController.fetchedObjects else {return 0}
        return toDoos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvTableToDoo.dequeueReusableCell(withIdentifier: "toDooCell") as! ToDooCell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell : ToDooCell, at : IndexPath) {
        let toDoo = fetechedResultsController.object(at: at)
        
        cell.lblTitulo.text = toDoo.titulo
        cell.lblDescricao.text = toDoo.descricao
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Mostra label se nao houver ToDoos
    func updateView(){
        var hasToDoos = false
        
        if let toDoos = fetechedResultsController.fetchedObjects {
            hasToDoos = toDoos.count > 0
        }
        
        tvTableToDoo.isHidden = !hasToDoos
        lblMessage.isHidden = hasToDoos
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            //Tenta fazer o fetch de ToDoos
            try self.fetechedResultsController.performFetch();
        } catch (let error) {
            self.showAlert(for: error.localizedDescription)
        }
        self.updateView();
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueAddToDooViewController {
            if let destinationViewController = segue.destination as?  NewToDooViewController {
                destinationViewController.managedObjectContext = contexto
            }
        } else if segue.identifier == segueEditToDoo {
            if let destinationViewController = segue.destination as?  NewToDooViewController {
                destinationViewController.toDoo = toDooAux
                destinationViewController.managedObjectContext = contexto
            }
        }
        else if segue.identifier == segueOpenToDooItemList {
            if let destinationViewController = segue.destination as? ToDooItemTableViewController {
                if let indexPath = self.tvTableToDoo.indexPathForSelectedRow {
                    let toDooSelecionado = fetechedResultsController.object(at: indexPath)
                    destinationViewController.toDooSelecionado = toDooSelecionado
                }
            }
        }
    }
    
    func deleteAction(at: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { (ac, UIView, success) in
            let toDoo = self.fetechedResultsController.object(at: at)
            toDoo.managedObjectContext?.delete(toDoo)
            do {
                try self.contexto.save()
            } catch {}
            success(true)
        })
        delete.image = ImageHelper.scaled(named: "trash", width: 30, height: 30)
        return delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    func editAction(at: IndexPath) -> UIContextualAction {
        let edit = UIContextualAction(style: .normal, title: nil, handler: { (ac, UIView, success) in
            self.toDooAux = self.fetechedResultsController.object(at: at)
            self.performSegue(withIdentifier: self.segueEditToDoo, sender: ac)
            success(true)
        })
        edit.image = ImageHelper.scaled(named: "edit", width: 30, height: 30)
        return edit
    }
    
//    func completeAction(at : IndexPath) -> UIContextualAction {
//        let complete = UIContextualAction(style: .normal, title: nil, handler: {(ac, UIView, success) in
//            let toDoo = self.fetechedResultsController.object(at: at)
//
//            toDoo.terminado = true
//
//            do {
//                try self.contexto.save()
//            } catch {}
//
//            success(true)
//        })
//        complete.backgroundColor = UIColor(named: "green-checked")
//        complete.image = ImageHelper.scaled(named: "checkmark", width: 30, height: 30)
//        return complete
//    }
//
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
//        let complete = completeAction(at: indexPath)
        edit.backgroundColor = .brown
        let configuration = UISwipeActionsConfiguration(actions: [edit])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
