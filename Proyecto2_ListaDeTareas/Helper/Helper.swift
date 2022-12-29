//
//  Helper.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 26/12/22.
//

import UIKit

class Helper
{
    static let dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    static func dateFormatter (dateString: String)  -> Date? {
        let date = dateFormatter.date(from: dateString)
        return date
    }
    
    
    static func validateText(text : String) -> Bool{
        if (text.trimmingCharacters(in: .whitespaces).isEmpty) {
            return false
        }
        return true
    }
    
    static func AlertMessageOk(title : String?, message : String, viewController : UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("ALERT_OK", comment: "ALERT_OK"), style: .default)
        alert.addAction(alertAction)
        viewController.present(alert, animated: true)
    }
    
//    static func AlertMessageError(title : String?, message : String, viewController : UIViewController)
//    {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let alertAction = UIAlertAction(title: "OK", style: .default)
//        alert.addAction(alertAction)
//        viewController.present(alert, animated: true)
//    }
    
}
