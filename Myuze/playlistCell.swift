//
//  playlistCell.swift
//  FoodTracker
//
//  Created by arya mirshafii on 7/22/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//




import Foundation
import UIKit

class playlistCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    /**
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
 
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        albumArt.layer.cornerRadius = albumArt.frame.size.width/2
        albumArt.clipsToBounds = true
        
        
        
        
        
        self.layer.borderWidth = 20
        self.layer.borderColor = UIColor.clear.cgColor
        
        
        
        
        
        
        
        self.backgroundColor = .clear
        
        self.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 4, width: self.contentView.frame.size.width - 25, height: self.contentView.frame.size.width - 35))
        
        whiteRoundedView.layer.backgroundColor = UIColor(red:0.77, green:0.79, blue:0.83, alpha:1.0).cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubview(toBack: whiteRoundedView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
