//
//  ListaTableViewCell.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 20/12/22.
//

import UIKit


protocol ListaTableViewCellDelegate {
    func checkBoxToggle(sender: ListaTableViewCell)
}

class ListaTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var delegate : ListaTableViewCellDelegate?
    
    @IBAction func checkBoxToggle(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
