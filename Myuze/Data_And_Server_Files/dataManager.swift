//
//  dataManager.swift
//  myuzicBackground
//
//  Created by Arya Mirshafii on 12/18/17.
//  Copyright © 2017 Arya Mirshafii. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import SwiftCSVExport

class dataManager{
    private var objectIDTable: [NSManagedObject] = []
    
    init(){
        self.loadData()
    }
    
    func aiTestFunction(){
        
        
    }
    
    func saveData(objectID:String, locationID:String){
        self.loadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
    
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            
            let objectEntity = NSEntityDescription.entity(forEntityName: "ObjectIDTable",
                                                          in: managedContext)!
            let dataToAppend = NSManagedObject(entity: objectEntity,
                                               insertInto: managedContext)
            
            dataToAppend.setValue(objectID, forKey: "theObjectID")
            dataToAppend.setValue(locationID, forKey: "locationID")
            objectIDTable.append(dataToAppend)
            try managedContext.save()
            
        }catch let error as NSError {
            // failure
            print("Fetch failed for saving the objectID table: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    
    func checkIfLocationExists(locationID:String) -> Bool{
        self.loadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ObjectIDTable")
        fetchRequest.predicate = NSPredicate(format: "locationID = %@", locationID)
        let managedContext = appDelegate.persistentContainer.viewContext
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        if(results.count > 0){print("it exists!")} else { print("it doesnt exist!")}
        print("it exists" + String(results.count > 0))
        return results.count > 0
        
        
    }
    
    func getObjectID(locationID: String) -> String{
        self.loadData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return "false"
        }
        var fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ObjectIDTable")
        fetchRequest.predicate = NSPredicate(format: "locationID = %@", locationID)
        let managedContext = appDelegate.persistentContainer.viewContext
        var results: [NSManagedObject] = []
        
        do {
            results = try managedContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.first!.value(forKey: "theObjectID") as! String
    }
    
    
    
    
    
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let objectIDTableRequest = NSFetchRequest<NSManagedObject>(entityName: "ObjectIDTable")
        
        do {
            objectIDTable = try managedContext.fetch(objectIDTableRequest)
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}



