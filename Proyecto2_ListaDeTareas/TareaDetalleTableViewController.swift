//
//  TareaDetalleTableViewController.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 26/12/22.
//

import UIKit

class TareaDetalleTableViewController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet var tareasDetalleTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var finalizadaCheck: UIButton!
    
    //MARK: --------- Propreties
    var tareaActual : Tarea?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tareaActual != nil {
            updateView()
        } 
    }
    
    
    @IBAction func exitButtonPressed(_ sender: UIBarButtonItem) {
        Salir()
    }
    
    
    @IBAction func dateSwitchChanged(_ sender: UISwitch) {
        dateLabel.textColor = (dateSwitch.isOn ? .black : .gray)
        tareasDetalleTableView.beginUpdates()
        tareasDetalleTableView.endUpdates()
    }
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func checkBoxChanged(_ sender: UIButton) {
    
        if tareaActual != nil {
            tareaActual?.finalizada = !(tareaActual!.finalizada)
            updateView()
        }
        
    }
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = Helper.dateFormatter.string(from: sender.date)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        updateData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var perform = false
        if Helper.validateText(text: titleTextField.text!){
            perform = true
        }else{
            
            Helper.AlertMessageOk(title: "Campo vacio", message: "El campo título no debe estar vació", viewController: self)
        }
        return perform
    }
    
    func updateView()
    {
        if tareaActual != nil{
            titleTextField.text = tareaActual?.titulo
            finalizadaCheck.isSelected = tareaActual?.finalizada ?? false
            dateLabel.text = Helper.dateFormatter.string(from: tareaActual?.fecha ?? Date())
            datePicker.date = tareaActual?.fecha ?? Date()
            dateLabel.textColor = (dateSwitch.isOn ? .black : .gray)
            noteTextView.text = tareaActual?.nota
        }
    }
    
    func updateData()
    {
        if tareaActual == nil {
            tareaActual = Tarea(context: context)
        }
        tareaActual?.titulo = titleTextField.text
        tareaActual?.finalizada  = finalizadaCheck.isSelected
        tareaActual?.fecha = datePicker.date
        tareaActual?.nota = noteTextView.text
    }
    
    private func Salir()
    {
        
        let esPresentadoEnModal = presentingViewController is UINavigationController
        if esPresentadoEnModal {
            dismiss(animated: true)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// ----- Extension ------

extension TareaDetalleTableViewController
{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 1, section: 1):
            return dateSwitch.isOn ? datePicker.frame.height : 0
        case IndexPath(row: 0, section: 2):
            return 180
       default:
            return 44
        }
    }
}
