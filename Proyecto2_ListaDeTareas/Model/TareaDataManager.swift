//
//  TareaDataManager.swift
//  Proyecto2_ListaDeTareas
//
//  Created by Omar Nieto on 26/12/22.
//

import Foundation
import CoreData

class TareaDataManager
{
    private var tareas : [Tarea] = []
    private var context : NSManagedObjectContext
    
    init(context : NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchData()
    {
        do{
            self.tareas = try self.context.fetch(Tarea.fetchRequest())
        }
        catch{
            print("ERROR: No se puede acceder a la base de datos de tareas: ", error.localizedDescription)
        }
    }
    
    func saveData()
    {
        do{
            try self.context.save()
        }
        catch{
            print("ERROR: No se puede acceder a salvar la base de datos de tareas: ", error.localizedDescription)
        }
    }
    
    func fetchWithCompountPredicate(title: String = "", date : String = "")
    {
        var predicates : [NSPredicate] = []
        
        if title.isEmpty && date.isEmpty {
            fetchData()
            return
        }
        
        if !(title.isEmpty) {
            predicates.append(NSPredicate(format: "titulo contains[cd] %@", title))
        }
        if !(date.isEmpty) {
            let dateIni = Helper.dateFormatter(dateString: date + " 00:00:00")
            let dateFin = Helper.dateFormatter(dateString: date + " 23:59:59")
            if dateIni != nil && dateFin != nil
            {
                predicates.append(NSPredicate(format: "(fecha >= %@) AND (fecha <= %@)", dateIni! as NSDate, dateFin! as NSDate))
            }
        }
        
        let compoundPredicates = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let fetchRequestWCP = NSFetchRequest<Tarea>(entityName: "Tarea")
        fetchRequestWCP.predicate = compoundPredicates
        
        do{
            tareas = try context.fetch(fetchRequestWCP)
        }
        catch{
            print("ERROR: al realizar la consulta con predicado")
        }
    }
    
    func fetchWithPredicate(searchValue: String)
    {
        do{
            let fetchRequestWP = NSFetchRequest<Tarea>(entityName: "Tarea")
            fetchRequestWP.predicate = NSPredicate(format: "titulo = %@", searchValue)
            tareas = try context.fetch(fetchRequestWP)
        }
        catch{
            print("ERROR: al realizar la consulta con predicado")
        }
    }
    
    
    func deleteTarea(at indice: Int)
    {
        deleteTarea(tarea: tareas[indice])
    }
    
    func deleteTarea(tarea : Tarea)
    {
        context.delete(tarea)
        saveData()
        fetchData()
    }
    
    func setTarea(tarea: Tarea, at index: Int)
    {
        tareas[index] = tarea
        saveData()
        fetchData()
    }
    
    func getTarea(at  indice: Int) -> Tarea
    {
        return tareas[indice]
    }
    
    func countTareas() -> Int{
        return tareas.count
    }
}


