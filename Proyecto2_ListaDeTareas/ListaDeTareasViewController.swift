//
//  ViewController.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 19/12/22.
//

import UIKit

class ListaDeTareasViewController: UIViewController {

    @IBOutlet weak var listaTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var titleSearchTextField: UITextField!
    @IBOutlet weak var dateSearchTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataManager : TareaDataManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager = TareaDataManager(context: context)
        dataManager?.fetchData()
        
        titleSearchTextField.delegate = self
        titleSearchTextField.returnKeyType = .search
        dateSearchTextField.returnKeyType = .search
        
        //Ocultar el teclado cuando se hace un tap fuera del campo de texto
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetalleTareaSegue" {
            let destination = segue.destination as! TareaDetalleTableViewController
            let selectionIndexRow = listaTableView.indexPathForSelectedRow?.row
            destination.tareaActual = dataManager?.getTarea(at: selectionIndexRow!)
        }
        else {
            if let selectedIndexPath = listaTableView.indexPathForSelectedRow {
                listaTableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue)
    {
        let source = segue.source as! TareaDetalleTableViewController
        if let selectedIndexPath = listaTableView.indexPathForSelectedRow
        {
            //Caso del uso del Navigatoin Controller (No modal)
            dataManager?.setTarea(tarea: source.tareaActual!, at: selectedIndexPath.row)
            listaTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
        else {
            //Caso de la presentacion Modal
            dataManager?.saveData()
            dataManager?.fetchData()
            listaTableView.reloadData()
        }
    }
   
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if listaTableView.isEditing {
            listaTableView.setEditing(false, animated: true)
            addButton.isEnabled = true
            sender.title = NSLocalizedString("BUTTON_EDIT", comment: "BUTTON_EDIT")
        } else {
            listaTableView.setEditing(true, animated: true)
            addButton.isEnabled = false
            sender.title = NSLocalizedString("BUTTON_DONE", comment: "BUTTON_DONE") 
        }
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        filtrarTareas()

    }
    
    func filtrarTareas()
    {
        let title = titleSearchTextField.text ?? ""
        let dateString  = dateSearchTextField.text ?? ""
        dataManager?.fetchWithCompountPredicate(title: title, date: dateString)
        listaTableView.reloadData()
    }
    
    
}


// ----------------Extension TableView Events -----------------------------------------------------------

extension ListaDeTareasViewController: UITableViewDelegate, UITableViewDataSource, ListaTableViewCellDelegate {
    
    func checkBoxToggle(sender: ListaTableViewCell) {
        if let selectedIndexPath = listaTableView.indexPath(for: sender){
            let tarea = dataManager?.getTarea(at: selectedIndexPath.row)
            tarea?.finalizada = !tarea!.finalizada
            dataManager?.saveData()
            dataManager?.fetchData()
            listaTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager?.countTareas() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tareaCell", for: indexPath) as! ListaTableViewCell
        cell.delegate = self
        let tarea = dataManager?.getTarea(at: indexPath.row)
        cell.titleLabel.text = tarea?.titulo ?? ""
        cell.checkBoxButton.isSelected = tarea?.finalizada ?? false
        cell.dateLabel.text = Helper.dateFormatter.string(from: tarea?.fecha ?? Date())
        return cell
    }
    
 
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if !listaTableView.isEditing {
            return nil
        }
        
        let action = UIContextualAction(style: .destructive, title: NSLocalizedString("ALERT_TITLE_BORRAR", comment: "ALERT_TITLE_BORRAR")) {(action, view, completionHandler) in
            self.dataManager?.deleteTarea(at: indexPath.row)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}


// ----- Extension TextField delegate ------
extension ListaDeTareasViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        filtrarTareas()
        return true
    }
}
