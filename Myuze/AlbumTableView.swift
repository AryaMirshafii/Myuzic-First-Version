//
//  AlbumTableView.swift
//  UITableViewController
//
//  Created by arya mirshafii on 6/23/17.
//  Copyright © 2017 Myuzick. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

class AlbumTableView : UITableViewController,UISearchBarDelegate {
    var albumsDict = [String:[MPMediaItem]]()
    var sectionTitles = [String]()
    var searchText = " "
    var isSearching = false
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            MPMediaLibrary.requestAuthorization({ (status) in
                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                       to: UIApplication.shared, for: nil)
                
                self.generateAlbumsDict(songs: MPMediaQuery.albums().items!)
                self.setUI()
                
            })
        case .authorized:
            self.generateAlbumsDict(songs: MPMediaQuery.albums().items!)
            self.setUI()
        default:
            break
        }
        
        self.tableView.rowHeight = 289
        
    }
    
    var previousAlbum = "someString"
    func generateAlbumsDict(songs: [MPMediaItem]){
        
        albumsDict.removeAll()
        for aSong in songs {
            if(aSong.artist != nil && aSong.albumTitle != nil){
                let key = aSong.albumTitle?.lowercased()
                if(aSong.albumTitle != previousAlbum){
                    albumsDict[key!] = [aSong]
                    previousAlbum = aSong.albumTitle!
                } else if var albumAtKey = albumsDict[key!] {
                    albumAtKey.append(aSong)
                    albumsDict[key!] = albumAtKey
                    
                }
            }
            
        }
        
        
        
        
        
        
        
        sectionTitles = [String](albumsDict.keys)
        sectionTitles = sectionTitles.sorted()
        
    }
    
    func setUI(){
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "BabyBlueAmbiantUpsideDOwn"))
        self.tableView.backgroundView = backgroundImage
        
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        
        
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexTrackingBackgroundColor = UIColor.black
        tableView.sectionIndexColor = UIColor.white
        
        
        
        self.searchBar.placeholder = "Search for a song, album, or artist"
        self.searchBar.delegate = self
        //self.searchBar.tintColor = .non
        self.searchBar.layer.backgroundColor = UIColor.clear.cgColor
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .clear
        
        self.searchBar.backgroundImage = UIColor.clear.convertImage()
        self.tableView.tableHeaderView = self.searchBar
        
    }
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
        let wordKey = sectionTitles[section].lowercased()
        
        if let songValues = albumsDict[wordKey.lowercased()]{
            return songValues.count
        }
         */
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "albumTableCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbumTableCell  else {
            fatalError("The dequeued cell is not an instance of songViewCell.")
        }
        
        let key = sectionTitles[indexPath.section]
        print(key)
        let songArray = albumsDict[key.lowercased()]
        
        //checks if artistname is empty
        if(songArray?[indexPath.row].artist != nil){
            cell.albumArtist.text = songArray?[indexPath.row].artist
            
        } else {
            cell.albumArtist.text = " "
        }
        //checks if albumart is empty
        if(songArray?[indexPath.row].artwork == nil){
            cell.albumArt.image = #imageLiteral(resourceName: "noArtworkFound")
        } else {
            cell.albumArt.image = songArray?[0].artwork?.image(at: CGSize(width: 200, height: 200))
        }
        
        
        cell.albumTitle.text = songArray?[0].albumTitle
        
        
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        let wordKey = sectionTitles[indexPath.section]
        let songArray = albumsDict[wordKey.lowercased()]
        tableView.deselectRow(at: indexPath, animated: true)
        let player = MPMusicPlayerController.applicationMusicPlayer
        let mediaCollection = MPMediaItemCollection(items: songArray!)
        player.setQueue(with: mediaCollection)
        player.play()
        
    }
    
    /**
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        let headerLabel = UILabel(frame: CGRect(x: 6, y: 10, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Arial", size: 28)
        
        //headerLabel.textColor = UIColor(red:0.00, green:0.40, blue:0.80, alpha:1.0)
        headerLabel.textColor = .white
        
        
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        //headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.sizeToFit()
        headerLabel.adjustsFontSizeToFitWidth = true
        
        headerView.addSubview(headerLabel)
        
        return headerView
    }
 
     */
    
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.frame.origin.y = max(0, scrollView.contentOffset.y)
        view.endEditing(true)
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
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("call me")
        if searchText.isEmpty {
            //self.addView.frame = CGRect(x: 0, y: 0, width: 357, height: 194)
            isSearching = false
            
            self.generateAlbumsDict(songs: MPMediaQuery.songs().items!)
            self.tableView.reloadData()
            print("ARYA SEARCHING")
            
            
        }else {
            
            
            isSearching = true
            
            filterTableView(text: searchText)
            
        }
        
        if searchBar.text == nil || searchBar.text == ""
        {
            
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        
    }
    
    
    func filterTableView(text: String) {
        
        //extracts all value in the dictionary
        let allSongs = albumsDict.flatMap(){ $0.1 }
        
        
        let songs = allSongs.filter({ (mod) -> Bool in
            
            
            return (mod.title?.lowercased().contains(text.lowercased()))! || (mod.albumTitle?.lowercased().contains(text.lowercased()))! ||
                (mod.artist?.lowercased().contains(text.lowercased()))!
        })
        self.generateAlbumsDict(songs: songs)
        
        self.tableView.reloadData()
        
    }
    
    
    
}
