//
//  songViewCell.swift
//  Myuze
//
//  Created by arya mirshafii on 10/30/17.
//  Copyright © 2017 Myuze. All rights reserved.
//

import Foundation
import UIKit

class songViewCell: UITableViewCell {
    @IBOutlet weak var albumArt: UIImageView!
    
    @IBOutlet weak var songNameLabel: UILabel!
    
    @IBOutlet weak var artistAlbumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumArt.layer.cornerRadius = albumArt.frame.size.width/2
        albumArt.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
