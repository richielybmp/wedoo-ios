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
    
    //Mostra label se nao houver ToDoos
    func updateView(){
        tvToDooItem.reloadData()
        var hasToDooItens = false
        
        if let toDooItens = toDooSelecionado?.itens {
            hasToDooItens = toDooItens.count > 0
        }

        tvToDooItem.isHidden = !hasToDooItens
        lblEmptyItemList.isHidden = hasToDooItens
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let toDooItens = toDooSelecionado?.itens else {return 0}
        return toDooItens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvToDooItem.dequeueReusableCell(withIdentifier: "toDooItemCell") as! ToDooItemCell

        let toDooItem = toDooSelecionado?.itens?[indexPath.row] as? ToDooItem

        cell.lblTitulo.text = toDooItem?.titulo
        cell.lblDescricao.text = toDooItem?.descricao
        cell.vStatus.backgroundColor = toDooItem!.status ? #colorLiteral(red: 0, green: 0.8457566353, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        return cell
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
        self.tvToDooItem.dataSource = self
        self.updateView();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tvToDooItem.reloadData()
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
                
                let indexPath = self.tvToDooItem.indexPathForSelectedRow!.row
                let toDooItem = toDooSelecionado?.itens?[indexPath] as? ToDooItem
                destinationViewController.toDooItemSelecionado = toDooItem
            }
        }
    }
}
