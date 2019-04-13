//
//  TableViewController.swift
//  WeDoo
//
//  Created by Mateus Augusto Stedler on 06/04/19.
//  Copyright © 2019 Richiely Paiva. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource {
    
    private let segueAddToDooViewController = "SegueAddToDooViewController"
    
    private let segueOpenToDooItemList = "SegueOpenToDooItemList"
    
    @IBOutlet weak var tvTableToDoo: UITableView!

    @IBOutlet weak var lblMessage: UILabel!
    
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
        
        let toDoo = fetechedResultsController.object(at: indexPath)
        
        cell.lblTitulo.text = toDoo.titulo
        cell.lblDescricao.text = toDoo.descricao
        
        return cell
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Swipe to Delete
        if editingStyle == .delete {
            let toDoo = fetechedResultsController.object(at: indexPath)
            
            toDoo.managedObjectContext?.delete(toDoo)
            
            do {
                try contexto.save()
            } catch {}
        }
    }
    
}
