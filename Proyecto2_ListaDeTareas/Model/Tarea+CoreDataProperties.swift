//
//  Tarea+CoreDataProperties.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 20/12/22.
//
//

import Foundation
import CoreData


extension Tarea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tarea> {
        return NSFetchRequest<Tarea>(entityName: "Tarea")
    }

    @NSManaged public var nota: String?
    @NSManaged public var fecha: Date?
    @NSManaged public var titulo: String?
    @NSManaged public var finalizada: Bool

}

extension Tarea : Identifiable {

}
