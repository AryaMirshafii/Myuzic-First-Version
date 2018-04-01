//
//  dataController.swift
//  coreDataTest
//
//  Created by arya mirshafii on 7/5/17.
//  Copyright © 2017 searchTest. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class dataController {
    var managedObjectContext: NSManagedObjectContext?
    //stores the keys for settings values
    struct defaultsKeys {
        static let shouldTransition = "false"
        static let songsOnServer = "0"
        
        
    }
    
    
    func fetchTilt() -> String {
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: defaultsKeys.shouldTransition) {
            // Some String Value
            return stringOne
        }
        return "false"
    }
    
    
    //alters the value of the setting keys
    func saveTilt(state: String) {
        let defaults = UserDefaults.standard
        defaults.set(state, forKey: defaultsKeys.shouldTransition)
        
    }
    
    
    func getNumberOfSongsOnServer() -> Int {
        let defaults = UserDefaults.standard
        if let number = defaults.string(forKey: defaultsKeys.songsOnServer) {
            // Some String Value
            return  Int(number)!
        }
        return 0
    }
    
    func saveNumberOfSongs(number: Int) {
        let numberOfSongs = String(number)
        let defaults = UserDefaults.standard
        defaults.set(numberOfSongs, forKey: defaultsKeys.songsOnServer)
        
    }
    
 
}
