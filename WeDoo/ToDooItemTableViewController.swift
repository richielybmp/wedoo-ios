//
//  ToDooItemTableViewController.swift
//  WeDoo
//
//  Created by Richiely Paiva on 12/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class ToDooItemTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let segueAddToDooItem = "SegueAddToDooItem"
    let segueEditToDooItem = "SegueEditToDooItem"
    var toDooSelecionado: ToDoo?
    
    @IBOutlet weak var tvToDooItem: UITableView!
    @IBOutlet weak var lblEmptyItemList: UILabel!
    
    var contexto: NSManagedObjectContext {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.persistentContainer.viewContext
    }
    
    fileprivate lazy var fetchedResultsController : NSFetchedResultsController<ToDooItem> = {
        //Cria um Fetch Request
        let fetchRequest: NSFetchRequest<ToDooItem> = ToDooItem.fetchRequest()
        
        //Configura Fetch Request para ordenar pela data de encerramento
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "criado_em", ascending: true)]
        
        fetchRequest.predicate = NSPredicate(format: "toDoo.id == %@", self.toDooSelecionado!.id!)
        
        //Cria o Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        //Metodos implementados em Utils/ToDooItemTableViewController+...
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    
    
    //Mostra label se nao houver ToDoos
    func updateView(){
        var hasToDooItens = false
        
        if let toDooItens = fetchedResultsController.fetchedObjects {
            hasToDooItens = toDooItens.count > 0
        }

        tvToDooItem.isHidden = !hasToDooItens
        lblEmptyItemList.isHidden = hasToDooItens
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let toDooItens = fetchedResultsController.fetchedObjects else {return 0}
        return toDooItens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvToDooItem.dequeueReusableCell(withIdentifier: "toDooItemCell") as! ToDooItemCell

        configureCell(cell, at: indexPath)
    
        return cell
    }
    
    func configureCell(_ cell : ToDooItemCell, at : IndexPath) {
        let toDooItem = fetchedResultsController.object(at: at)
        
        cell.lblTitulo.text = toDooItem.titulo
        cell.lblDescricao.text = toDooItem.descricao
        cell.vStatus.backgroundColor = toDooItem.status ? #colorLiteral(red: 0, green: 0.8457566353, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
   
    }
    
    func deleteAction(at: IndexPath) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { (ac, UIView, success) in
            let toDooItem = self.toDooSelecionado?.itens?[at.row] as? ToDooItem
            
            self.toDooSelecionado?.managedObjectContext?.delete(toDooItem!)
            
            do {
                try self.contexto.save()
            } catch {}
            success(true)
        })
        delete.image = ImageHelper.scaled(named: "trash", width: 30, height: 30)
        return delete
    }
    
    
    func completeAction(at : IndexPath) -> UIContextualAction {
        let toDooItem = self.toDooSelecionado?.itens![at.row] as? ToDooItem
        let complete = UIContextualAction(style: .normal, title: nil, handler: {(ac, UIView, success) in
            
            toDooItem!.status = !toDooItem!.status
            
            do {
                try self.contexto.save()
            } catch {}
            
            success(true)
            self.tvToDooItem.reloadData()
        })
        
        if toDooItem!.status {
            complete.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            complete.image = ImageHelper.scaled(named: "cross", width: 30, height: 30)
            
        }
        else {
            complete.backgroundColor = UIColor(named: "green-checked")
            complete.image = ImageHelper.scaled(named: "checkmark", width: 30, height: 30)
        }
        
        return complete
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [complete])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = toDooSelecionado?.titulo
        do {
            //Tenta fazer o fetch de ToDoos
            try self.fetchedResultsController.performFetch();
        } catch (let error) {
            self.showAlert(for: error.localizedDescription)
        }
        self.updateView();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAddToDooItem {
            if let destinationViewController = segue.destination as?  NewToDooItemViewController {
                destinationViewController.managedObjectContext = contexto
                destinationViewController.toDooSelecionado = self.toDooSelecionado
            }
        }
        else if segue.identifier == segueEditToDooItem {
            if let destinationViewController = segue.destination as? NewToDooItemViewController {
                destinationViewController.managedObjectContext = contexto
                destinationViewController.toDooSelecionado = self.toDooSelecionado
                
                let indexPath = self.tvToDooItem.indexPathForSelectedRow!
                let toDooItem = fetchedResultsController.object(at: indexPath)
                destinationViewController.toDooItemSelecionado = toDooItem
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
