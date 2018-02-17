//
//  AlbumTableCell.swift
//  Myuzick
//
//  Created by arya mirshafii on 6/23/17.
//  Copyright © 2017 Myuzick. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class AlbumTableCell:UITableViewCell {

    
    
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
    var songs = [MPMediaItem]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumArt.layer.cornerRadius = albumArt.frame.size.width/2
        albumArt.clipsToBounds = true
        
        
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
