//
//  TableViewController.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 06/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData
import TTGSnackbar

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let segueAddToDooViewController = "SegueAddToDooViewController"
    private let segueEditToDoo = "SegueEditToDoo"
    private let segueOpenToDooItemList = "SegueOpenToDooItemList"
    
    private var toDooAux: ToDoo?
    
    @IBOutlet weak var tvTableToDoo: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var contexto: NSManagedObjectContext = AppManagedContext.ManagedContext()
    
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
    
    func configureCell(_ cell : ToDooCell, at : IndexPath){
        let toDoo = fetechedResultsController.object(at: at)
        
        cell.lblTitulo.text = toDoo.titulo
        cell.lblDescricao.text = toDoo.descricao
        
        let qtdItens = toDoo.itens?.count
        let label = qtdItens! < 2 ? " item" : " itens"
        cell.lblItens.text = qtdItens!.description + label
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == segueEditToDoo {
            if let destinationViewController = segue.destination as?  NewToDooViewController {
                destinationViewController.toDoo = toDooAux
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
            self.contexto.delete(toDoo)
            do {
                let snackbar = TTGSnackbar(message: toDoo.titulo! + " Excluído", duration: .middle)
                
                try self.contexto.save()
                
                snackbar.actionText = "Desfazer"
                snackbar.actionTextColor = .white
                snackbar.actionBlock = { (snackbar) in self.contexto.undo();
                    do {
                        try self.contexto.save()
                    } catch {
                        print("\(error.localizedDescription)")
                    }
                }
                snackbar.show()
            } catch {
                print("\(error.localizedDescription)")
            }
            success(true)
        })
        delete.image = ImageHelper.scaled(named: "trash", width: 30, height: 30)
        return delete
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        edit.backgroundColor = .brown
        let configuration = UISwipeActionsConfiguration(actions: [edit])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }

}
