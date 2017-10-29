//
//  mainView.swift
//  Myuze
//
//  Created by arya mirshafii on 10/29/17.
//  Copyright © 2017 Myuze. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import MarqueeLabel

class mainView: UIViewController {
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundShadowImage: UIImageView!
    @IBOutlet weak var albumBackgroundImage: UIImageView!
    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var songNameLabel: MarqueeLabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var artistNameLabel: MarqueeLabel!
    @IBOutlet weak var playlistSelectorView: UIView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var smartShuffleButton: UIButton!
    
    
    
    
    var player = MPMusicPlayerController.applicationMusicPlayer
    var mediaItems:[MPMediaItem]!
    var volumeSlider: MPVolumeView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewDidAppear(_ animated: Bool){
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization({ (status) in
                self.startPlaying()
                self.updateUI()
            })
        case .authorized:
            self.startPlaying()
            self.updateUI()
        default:
            break
        }
    }
    
    func startPlaying(){
        mediaItems = MPMediaQuery.albums().items!
        let mediaCollection = MPMediaItemCollection(items: self.mediaItems)
        self.player.setQueue(with: mediaCollection)
        player.prepareToPlay()
    }
    func setUI(){
        albumArtImage.layer.cornerRadius = albumArtImage.frame.height/2
        albumArtImage.clipsToBounds = true
        
        
        albumBackgroundImage.layer.cornerRadius = albumBackgroundImage.frame.height/2
        albumBackgroundImage.clipsToBounds = true
        albumBackgroundImage.layer.shadowColor = UIColor.black.cgColor
        albumBackgroundImage.layer.shadowOpacity = 0.2
        albumBackgroundImage.layer.shadowOffset = CGSize.zero
        albumBackgroundImage.layer.shadowRadius = 30
        albumBackgroundImage.layer.shadowPath = UIBezierPath(roundedRect: albumBackgroundImage.bounds, cornerRadius: albumBackgroundImage.frame.size.width/2).cgPath
        
        
        self.backgroundShadowImage.clipsToBounds = false
        self.backgroundShadowImage.layer.shadowColor = UIColor.black.cgColor
        self.backgroundShadowImage.layer.shadowOpacity = 0.6
        self.backgroundShadowImage.layer.shadowOffset = CGSize.zero
        self.backgroundShadowImage.layer.shadowRadius = 10
        self.backgroundShadowImage.layer.shadowPath = UIBezierPath(roundedRect: self.backgroundShadowImage.bounds, cornerRadius: self.backgroundShadowImage.frame.size.width/2).cgPath
        
        self.shuffleButton.layer.shadowColor = UIColor.black.cgColor
        self.shuffleButton.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.shuffleButton.layer.shadowRadius = 3
        self.shuffleButton.layer.shadowOpacity = 0.6
        
        
        self.repeatButton.layer.shadowColor = UIColor.black.cgColor
        self.repeatButton.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.repeatButton.layer.shadowRadius = 3
        self.repeatButton.layer.shadowOpacity = 0.6
        
        
        self.durationSlider.layer.shadowColor = UIColor.black.cgColor
        self.durationSlider.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.durationSlider.layer.shadowRadius = 3
        self.durationSlider.layer.shadowOpacity = 0.6
        
        
        self.volumeSlider?.layer.shadowColor = UIColor.black.cgColor
        self.volumeSlider?.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.volumeSlider?.layer.shadowRadius = 3
        self.volumeSlider?.layer.shadowOpacity = 0.6
        
        
        
        self.artistNameLabel?.layer.shadowColor = UIColor.black.cgColor
        self.artistNameLabel?.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.artistNameLabel?.layer.shadowRadius = 3
        self.artistNameLabel?.layer.shadowOpacity = 0.6
        
        
        self.songNameLabel?.layer.shadowColor = UIColor.black.cgColor
        self.songNameLabel?.layer.shadowOffset =  CGSize(width: 5, height: 5)
        self.songNameLabel?.layer.shadowRadius = 3
        self.songNameLabel?.layer.shadowOpacity = 0.6
        
        //self.durationSlider.setThumbImage(UIImage(named: "sliderBar.png"), for: .normal)
        
        
        //sets the volume slider controller
        self.volumeView.backgroundColor = UIColor.clear
        self.volumeSlider = MPVolumeView(frame: self.volumeView.bounds)
        self.volumeView.addSubview(self.volumeSlider!)
        //self.volumeSlider?.setVolumeThumbImage(UIImage(named: "sliderBar.png"), for: .normal)
        self.backgroundImage.image = #imageLiteral(resourceName: "solidBlack")
        
        
    }
    func updateUI(){
        //sets the album artwork
        if(player.nowPlayingItem?.artwork != nil){
            albumArtImage.image = player.nowPlayingItem?.artwork?.image(at: albumArtImage.frame.size)
        } else {
            albumArtImage.image = #imageLiteral(resourceName: "noArtworkFound")
        }
        
        /// sets the name of the song
        if(player.nowPlayingItem?.title != nil){
            songNameLabel.text = player.nowPlayingItem?.title!
        }
        //sets the artist label
        if(player.nowPlayingItem?.albumTitle != nil && player.nowPlayingItem?.artist != nil ){
            artistNameLabel.text = (player.nowPlayingItem?.artist!)! + " - " + (player.nowPlayingItem?.albumTitle!)!
        } else if(player.nowPlayingItem?.albumTitle != nil && player.nowPlayingItem?.artist == nil ){
            artistNameLabel.text = player.nowPlayingItem?.artist!
        } else if(player.nowPlayingItem?.albumTitle == nil && player.nowPlayingItem?.artist != nil ){
            artistNameLabel.text = player.nowPlayingItem?.albumTitle!
        }
        
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
