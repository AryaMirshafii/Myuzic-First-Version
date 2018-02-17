//
//  Playlist.swift
//  FoodTracker
//
//  Created by arya mirshafii on 7/20/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation
import MediaPlayer


class Playlist {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var songs = [MPMediaItem]()
    
    
    //MARK: Initialization
    
   
    
    
    init?(name: String, photo: UIImage?,songs: [MPMediaItem]) {
        
        //
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.songs = songs
        
    }
    
    
    

}

