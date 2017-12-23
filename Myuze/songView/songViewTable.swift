//
//  songViewTable.swift
//  Myuze
//
//  Created by arya mirshafii on 10/30/17.
//  Copyright © 2017 Myuze. All rights reserved.
//

import UIKit
import MediaPlayer

class songViewTable:UITableViewController, UISearchBarDelegate {
    var songsDict = [String:[MPMediaItem]]()
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
                self.generateSongsDict(songs: MPMediaQuery.songs().items!)
                self.setUI()
                
            })
        case .authorized:
            self.generateSongsDict(songs: MPMediaQuery.songs().items!)
            self.setUI()
        default:
            break
        }
        
        
        
       
    }
    
    
    func generateSongsDict(songs: [MPMediaItem]){
        
        songsDict.removeAll()
        for aSong in songs {
            
            var key = "\(aSong.title![(aSong.title?.startIndex)!])"
            key = key.lowercased()
            if var songsAtKey = songsDict[key] {
                songsAtKey.append(aSong)
                songsDict[key] = songsAtKey
                
            } else {
                songsDict[key] = [aSong]
            }
        }
        
        sectionTitles = [String](songsDict.keys)
        sectionTitles = sectionTitles.sorted()
        
    }
    
    func setUI(){
        tableView.backgroundColor = UIColor.black
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        
        
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexTrackingBackgroundColor = UIColor.black
        tableView.sectionIndexColor = UIColor.white
        
        
        
        self.searchBar.backgroundColor = .black
        self.searchBar.placeholder = "Search for a song, album, or artist"
        self.searchBar.delegate = self
        self.searchBar.tintColor = .black
        self.searchBar.layer.backgroundColor = UIColor.black.cgColor
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .black
        self.searchBar.backgroundImage = #imageLiteral(resourceName: "solidBlack")
        self.tableView.tableHeaderView = self.searchBar
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sectionTitles[section].uppercased()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wordKey = sectionTitles[section].lowercased()
        
        if let songValues = songsDict[wordKey.lowercased()]{
            return songValues.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "songViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? songViewCell  else {
            fatalError("The dequeued cell is not an instance of songViewCell.")
        }
        
        let key = sectionTitles[indexPath.section]
        print(key)
        let songArray = songsDict[key.lowercased()]
        
        //checks if artistname is empty
        if(songArray?[indexPath.row].artist != nil){
            cell.artistAlbumLabel.text = songArray?[indexPath.row].artist
            
        } else {
            cell.artistAlbumLabel.text = " "
        }
        //checks if albumart is empty
        if(songArray?[indexPath.row].artwork == nil){
            cell.albumArt.image = #imageLiteral(resourceName: "noArtworkFound")
        } else {
            cell.albumArt.image = songArray?[indexPath.row].artwork?.image(at: CGSize(width: 200, height: 200))
        }
        
        
        cell.songNameLabel.text = songArray?[indexPath.row].title
        
       
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        let wordKey = sectionTitles[indexPath.section]
        //print(wordKey)
        let songArray = songsDict[wordKey.lowercased()]
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let player = MPMusicPlayerController.applicationMusicPlayer
        let song = songArray?[indexPath.row]
        
        let mediaCollection = MPMediaItemCollection(items: [song!])
        player.setQueue(with: mediaCollection)
        player.play()
        
        tableView.sectionIndexColor = UIColor.white
        
    }
    
    
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
    
    
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = sectionTitles.index(of: title) else {
            
            return -1
        }
        
        return index
        
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return sectionTitles
        
    }
    
    
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
            
            self.generateSongsDict(songs: MPMediaQuery.songs().items!)
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
        let allSongs = songsDict.flatMap(){ $0.1 }

        
        let songs = allSongs.filter({ (mod) -> Bool in
            
            
            return (mod.title?.lowercased().contains(text.lowercased()))! || (mod.albumTitle?.lowercased().contains(text.lowercased()))! ||
            (mod.artist?.lowercased().contains(text.lowercased()))!
        })
        self.generateSongsDict(songs: songs)
        
        self.tableView.reloadData()
        
    }
    
    
    
    
}
