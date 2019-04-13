//
//  ToDooItemTableViewController.swift
//  WeDoo
//
//  Created by Richiely Paiva on 12/04/19.
//  Copyright © 2019 Filipe Maciel, Mateus Stedler, Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class ToDooItemTableViewController: UIViewController, UITableViewDataSource {
    
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

        return cell
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
