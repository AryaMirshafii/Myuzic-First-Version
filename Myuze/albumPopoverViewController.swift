//
//  albumPopoverViewController.swift
//  Myuze
//
//  Created by Arya Mirshafii on 12/29/17.
//  Copyright © 2017 Myuze. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import MarqueeLabel

class albumPopoverViewController: UITableViewController {
    
    @IBOutlet weak var albumNameLabel: MarqueeLabel!
    @IBOutlet weak var artistNameLabel: MarqueeLabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    var songs:[MPMediaItem]!
    var player = MPMusicPlayerController.applicationMusicPlayer
    override func viewDidLoad() {
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "BabyBlueAmbiant"))
        
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.shadowImage = UIImage()
        self.tableView.backgroundView = backgroundImage
        super.viewDidLoad()
        print("the name is " + songs[0].albumTitle! )
        albumNameLabel.text = songs[0].albumTitle
        artistNameLabel.text = songs[0].artist
        if(songs[0].artwork == nil){
           
            
            
            albumImageView.image = #imageLiteral(resourceName: "noArtworkFound")
            
        } else {
            albumImageView.image = songs[0].artwork?.image(at: CGSize(width: 110, height: 110))
        }
       
        albumImageView.layer.cornerRadius = albumImageView.frame.size.width/2
        albumImageView.clipsToBounds = true
        navBar.setBackgroundImage(UIColor.clear.convertImage(), for: .default)
        
    }
    
    @IBAction func dismissTheView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func playAllSongs(_ sender: Any) {
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return songs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "songViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? songViewCell  else {
            fatalError("The dequeued cell is not an instance of songViewCell.")
        }
        
        //let key = sectionTitles[indexPath.section]
       
        
        //checks if artistname is empty
        if(songs?[indexPath.row].artist != nil){
            cell.artistAlbumLabel.text = songs?[indexPath.row].artist
            
        } else {
            cell.artistAlbumLabel.text = " "
        }
        //checks if albumart is empty
        if(songs?[indexPath.row].artwork == nil){
            cell.albumArt.image = #imageLiteral(resourceName: "noArtworkFound")
        } else {
            cell.albumArt.image = songs?[indexPath.row].artwork?.image(at: CGSize(width: 110, height: 110))
        }
        
        
        cell.songNameLabel.text = songs?[indexPath.row].title
        
        
        return cell
            
            
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        view.endEditing(true)
        let song = songs?[indexPath.row]
        //songs.append(song!)
        let mediaCollection = MPMediaItemCollection(items: songs)
        player.setQueue(with: mediaCollection)
        
        player.nowPlayingItem = song
        player.play()
        dismiss(animated: true, completion: nil)
        
        
        
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let tableHeaderView = tableView.tableHeaderView {
            tableView.bringSubview(toFront: tableHeaderView)
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
