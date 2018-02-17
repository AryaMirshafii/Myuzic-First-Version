//
//  tablePlayerCell.swift
//  MyuzicFinal
//
//  Created by arya mirshafii on 8/26/17.
//  Copyright © 2017 Myuzic. All rights reserved.
//

import Foundation
import UIKit



class tablePlayerCell:  UITableViewCell{
    
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shapeButtons(theButton: playButton)
        shapeButtons(theButton: shuffleButton)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func shapeButtons(theButton: UIButton){
        theButton.layer.cornerRadius = 15
        theButton.layer.borderWidth = 3
        theButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
