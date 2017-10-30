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
extension UILabel {
    
   
}
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
    @IBOutlet weak var swipeZone: UIView!
    
    
    
    
    var player = MPMusicPlayerController.applicationMusicPlayer
    var mediaItems:[MPMediaItem]!
    var volumeSlider: MPVolumeView?
    
    var timer = Timer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        durationSlider.addTarget(self, action: #selector(setDurationValue), for: [.touchUpInside, .touchUpOutside])
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        swipeZone.addGestureRecognizer(tap)
        
        
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(gesture:)))
        swipeRight.addTarget(self, action: #selector(self.handleSwipe(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.cancelsTouchesInView = false
        swipeZone.addGestureRecognizer(swipeRight)
        //self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(gesture:)))
        swipeLeft.cancelsTouchesInView = false
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.swipeZone.addGestureRecognizer(swipeLeft)
        
        
        
        
        
        
        self.player.beginGeneratingPlaybackNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.updateUI), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange , object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.updatePlaybackUI), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange , object: nil)
        
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
        player.pause()
        updateDuration()
    }
    
    
    
    
    @objc func updatePlaybackUI(){
        if(player.playbackState == .paused){
            albumBackgroundImage.layer.backgroundColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0).cgColor
            timer.invalidate()
        } else if(player.playbackState == .playing){
             timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDuration), userInfo: nil, repeats: true)
            albumBackgroundImage.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    @objc func updateDuration(){
        durationSlider.maximumValue = Float((player.nowPlayingItem?.playbackDuration)!)
        durationSlider.setValue(Float(player.currentPlaybackTime), animated: false)
        
        currentTimeLabel.text = secondsToMinutesSeconds(seconds: Int(durationSlider.value))
        timeRemainingLabel.text = secondsToMinutesSeconds(seconds: Int(durationSlider.maximumValue-durationSlider.value))
        
    }
    
    func secondsToMinutesSeconds (seconds : Int) -> (String) {
        let minutes = String((seconds % 3600) / 60)
        var secondsString = String((seconds % 3600) % 60)
        
        if(secondsString.characters.count == 1 && ((seconds % 3600) % 60) > 10) {
            secondsString += "0"
        }else if (secondsString.characters.count == 1 && ((seconds % 3600) % 60) < 10){
            secondsString = "0" + secondsString
        }
        return minutes + ":" + secondsString
    }
    @objc func setDurationValue(){
        player.currentPlaybackTime = TimeInterval(durationSlider.value)
    }
    
    var counter = 0
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        counter += 1
        
        if( counter % 2 == 1){
            player.play()
            print("playing")
            //player.playbackState = .playing
            albumBackgroundImage.layer.backgroundColor = UIColor.clear.cgColor
            
        }
        if(counter % 2 == 0){
            player.pause()
            print("paused")
            //player.playbackState = .paused
            albumBackgroundImage.layer.backgroundColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0).cgColor
        }
        
        
    }
    
    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                player.skipToPreviousItem()
                print("going back")
            case UISwipeGestureRecognizerDirection.left:
                player.skipToNextItem()
                print("going forward")
            default:
                break
            }
        }
        
        
        
        
    }
    
    func setUI(){
        self.backgroundImage.image = #imageLiteral(resourceName: "solidBlack")
        self.playlistSelectorView.backgroundColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        self.playlistSelectorView.layer.cornerRadius = playlistSelectorView.frame.height/2
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
        
        self.durationSlider.setThumbImage(UIImage(named: "sliderBar.png"), for: .normal)
        durationSlider.maximumTrackTintColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        durationSlider.minimumTrackTintColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        
        //sets the volume slider controller
        self.volumeView.backgroundColor = UIColor.clear
        self.volumeSlider = MPVolumeView(frame: self.volumeView.bounds)
        self.volumeView.addSubview(self.volumeSlider!)
        self.volumeSlider?.setVolumeThumbImage(UIImage(named: "sliderBar.png"), for: .normal)
        self.volumeSlider?.tintColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        
        
        
       
        
        
        
        
        
    }
    
    @objc func updateUI(){
        //sets the album artwork
        if(player.nowPlayingItem?.artwork != nil){
            albumArtImage.image = player.nowPlayingItem?.artwork?.image(at: albumArtImage.frame.size)
            print(albumArtImage.frame.size)
        } else {
            let anImage = #imageLiteral(resourceName: "noArtworkFound")
            //anImage.sizeThatFits(albumArtImage.frame.size)
            albumArtImage.image = anImage
        }
        
        /// sets the name of the song
        if(player.nowPlayingItem?.title != nil){
            songNameLabel.text = player.nowPlayingItem?.title!
        }
        //sets the artist label
        if(player.nowPlayingItem?.albumTitle != nil && player.nowPlayingItem?.artist != nil ){
            artistNameLabel.text = (player.nowPlayingItem?.artist!)! + " - " + (player.nowPlayingItem?.albumTitle!)!
        } else if(player.nowPlayingItem?.albumTitle != nil && player.nowPlayingItem?.artist == nil ){
            artistNameLabel.text = player.nowPlayingItem?.albumTitle!
        } else if(player.nowPlayingItem?.albumTitle == nil && player.nowPlayingItem?.artist != nil ){
            artistNameLabel.text = player.nowPlayingItem?.artist!
        }
        
        //sets the values of the sliders
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
