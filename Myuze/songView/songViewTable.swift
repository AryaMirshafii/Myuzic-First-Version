//
//  songViewTable.swift
//  Myuze
//
//  Created by arya mirshafii on 10/30/17.
//  Copyright © 2017 Myuze. All rights reserved.
//

import UIKit
import MediaPlayer
public extension UIColor {
    func convertImage() -> UIImage {
        let rect : CGRect = CGRect(x:0,y: 0,width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(self.cgColor)
        context.fill(rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

class songViewTable:UITableViewController, UISearchBarDelegate {
    var player = MPMusicPlayerController.applicationMusicPlayer
    var songsDict = [String:[MPMediaItem]]()
    var sectionTitles = [String]()
    var searchText = " "
    var isSearching = false
    var userInfo = dataController()
    
    
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(!isSearching || searchBar.text == nil){
            print("you are not searching")
            self.generateSongsDict(songs: MPMediaQuery.songs().items!)
            self.setUI()
        }
        var textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .white
        
        
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongTap(_:)))
        view.addGestureRecognizer(hold)
        
        
       
    }
    @objc func handleLongTap(_ sender: UILongPressGestureRecognizer){
        print("Tapped longly")
        userInfo.saveTilt(state: "true")
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
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "BabyBlueAmbiantUpsideDOwn"))
        self.tableView.backgroundView = backgroundImage
        self.tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexColor = UIColor(red:0.15, green:0.65, blue:0.93, alpha:1.0)
        
        
        tableView.sectionIndexBackgroundColor  = UIColor.clear
        //tableView.sectionIndexTrackingBackgroundColor = UIColor.black
        tableView.sectionIndexColor = UIColor.white
        
        
        
        //self.searchBar.backgroundColor = .black
        self.searchBar.placeholder = "Search for a song, album, or artist"
        self.searchBar.delegate = self
        //self.searchBar.tintColor = .non
        self.searchBar.layer.backgroundColor = UIColor.clear.cgColor
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .clear
        
        self.searchBar.backgroundImage = UIColor.clear.convertImage()
        self.tableView.tableHeaderView = self.searchBar
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(isSearching){
            self.tableView.sectionIndexColor = .clear
            return sectionTitles[section]
        }
        
        return sectionTitles[section].uppercased()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionTitles.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching){
            return (songsDict[sectionTitles[section]]?.count)!
        } else {
            let wordKey = sectionTitles[section].lowercased()
            if let songValues = songsDict[wordKey.lowercased()]{
                return songValues.count
            }
        }
        
        
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = sectionTitles[indexPath.section]
        
        
        if(key == "artists"){
            
        }else if(key == "Albums"){
            let cellIdentifier = "albumTableCell"
            
            self.tableView.rowHeight = 246
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbumTableCell  else {
                fatalError("The dequeued cell is not an instance of AlbumTableCell.")
            }
            
           
            
            let songArray = songsDict["Albums"]
            cell.songs = [songArray![indexPath.row]]
            
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
                cell.albumArt.image = songArray?[indexPath.row].artwork?.image(at: CGSize(width: 200, height: 200))
            }
            
            
            cell.albumTitle.text = songArray?[indexPath.row].albumTitle
            return cell
        }else if(key == "Songs"){
            self.tableView.rowHeight = 90
            let cellIdentifier = "songViewCell"
            
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? songViewCell  else {
                fatalError("The dequeued cell is not an instance of songViewCell.")
            }
            
            //let key = sectionTitles[indexPath.section]
            
            let songArray = songsDict[key]
            
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
        }else if(!isSearching) {
            self.tableView.rowHeight = 90
            let cellIdentifier = "songViewCell"
            
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? songViewCell  else {
                fatalError("The dequeued cell is not an instance of songViewCell.")
            }
            
            //let key = sectionTitles[indexPath.section]
            
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
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        view.endEditing(true)
        let player = MPMusicPlayerController.applicationMusicPlayer
        if let theCell = self.tableView.cellForRow(at: indexPath) as? AlbumTableCell{
           
            let albumName:String = theCell.songs[0].albumTitle!
            
            let albumFilter = MPMediaQuery.albums().items?.filter({ (mod) -> Bool in
                
                
                return (mod.albumTitle != nil && (mod.albumTitle?.lowercased().contains(albumName.lowercased()))!)
            })
            if(!(albumFilter?.isEmpty)!){
                
                let mediaCollection = MPMediaItemCollection(items: albumFilter!)
                player.setQueue(with: mediaCollection)
                player.play()
            }
        } else {
            let wordKey = sectionTitles[indexPath.section]
            
            let songArray = songsDict[wordKey]
            
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            let song = songArray?[indexPath.row]
            
            let mediaCollection = MPMediaItemCollection(items: [song!])
            player.setQueue(with: mediaCollection)
            player.play()
            
            tableView.sectionIndexColor = UIColor.white
            
        }
        
        if(isSearching){
            searchBar.text = nil
            self.generateSongsDict(songs: MPMediaQuery.albums().items!)
            self.isSearching = false
            self.tableView.rowHeight = 80
            self.tableView.reloadData()
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        //tableView.bounds.size.height
        let headerLabel = UILabel(frame: CGRect(x: 6, y: 0, width:
            tableView.bounds.size.width, height: 90))
        headerLabel.font = UIFont(name: "Arial", size: 28)
        
        //headerLabel.textColor = UIColor(red:0.00, green:0.40, blue:0.80, alpha:1.0)
        headerLabel.textColor = .white
        
        
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        //headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.sizeToFit()
        //headerLabel.clipsToBounds = true
        headerLabel.clipsToBounds = true
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
        
        if searchText.isEmpty {
            //self.addView.frame = CGRect(x: 0, y: 0, width: 357, height: 194)
            isSearching = false
            
            self.generateSongsDict(songs: MPMediaQuery.songs().items!)
            self.tableView.rowHeight = 80
            self.tableView.reloadData()
            
            
            
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
        
        
        self.sectionTitles = ["Songs","Albums"]
        
        let allSongs = MPMediaQuery.albums().items!

        
        
        
        
        let artistFilter = allSongs.filter({ (mod) -> Bool in
            
            
            return (mod.artist != nil && (mod.artist?.lowercased().contains(text.lowercased()))!)
        })
        
        
        
        let titleFilter = allSongs.filter({ (mod) -> Bool in
           
            
            return (mod.title != nil && (mod.title?.lowercased().contains(text.lowercased()))!)
        })
        
        
        var albumFilter = allSongs.filter({ (mod) -> Bool in
            
            
            return (mod.albumTitle != nil && (mod.albumTitle?.lowercased().contains(text.lowercased()))!)
        })
        
 
        var blankArray = [MPMediaItem]()
        var previousAlbumTitle = ""
        for aSong in albumFilter {
            if(previousAlbumTitle != aSong.albumTitle){
                blankArray.append(aSong)
                previousAlbumTitle = aSong.albumTitle!
            }
        }
        albumFilter = blankArray
        
          // + albumFilter + titleFilter
        
        self.generateSearchDict(songSortedByName: titleFilter, songSortedByAlbum: albumFilter, songSortedByArtist: artistFilter)
        //self.generateSongsDict(songs: overallSongs)
        
        self.tableView.reloadData()
        
        
    }
    
    
    func generateSearchDict(songSortedByName:[MPMediaItem], songSortedByAlbum:[MPMediaItem], songSortedByArtist:[MPMediaItem]){
        self.songsDict.removeAll()
    
        var albumArtistCombo = songSortedByAlbum
        var previousAlbumTitle = ""
        for aSong in songSortedByArtist{
            if(aSong.albumTitle != nil && previousAlbumTitle != aSong.albumTitle){
                albumArtistCombo.append(aSong)
                 previousAlbumTitle = aSong.albumTitle!
            }
        }
        
        if(!songSortedByAlbum.isEmpty){
            self.songsDict["Albums"] = albumArtistCombo
        }
        
        if(!songSortedByName.isEmpty){
            self.songsDict["Songs"] = songSortedByName + songSortedByArtist
        }
        
        
        self.sectionTitles = [String](songsDict.keys)
        
    }
    
    
    
    
}
