//
//  playlistTableView.swift
//  FoodTracker
//
//  Created by arya mirshafii on 7/27/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//




import UIKit
import MediaPlayer

class playlistTableView: UITableViewController,UISearchBarDelegate {
    
    //MARK: Properties
    
    //var meals = [Meal]()
    var playlistArray = [Playlist]()
    var songTitle: String?
    var artistTitle: String?
    var albumName: String?
    var albumArt: UIImage?
    var songsToShow = [MPMediaItem]()
    var thePlaylist: [MPMediaItem]?
    var listOsongs = [MPMediaItem]()
    
    
    
    let datamanager = dataManager()
    
    var searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
    
    var songSearch = [MPMediaItem]()
    var songArtist: String!
    var songAlbum: String!
    var searchAppend = [MPMediaItem]()
    
    var fullSongs = [MPMediaItem]()
    var isTyping = false
    var selectedPlaylist: Playlist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "BabyBlueAmbiantUpsideDOwn"))
        self.tableView.backgroundView = backgroundImage
        /**
        let aframe = CGRect(x: 0, y: 0, width: self.view.frame.width, height: ceil(self.view.frame.height * 0.03248875562))
        let aView = UIView(frame: aframe)
        aView.backgroundColor = background.getCellColor(theTheme: datamanager.fetchData())
        self.tableView.tableHeaderView = aView
        */
        DispatchQueue.global().async {
            self.loadPlaylists()
            self.loadSearchSongs()
        }
       tableView.rowHeight = 120
        
        
        
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        
        if searchText.isEmpty {
            isTyping = false
            tableView.sectionIndexColor = UIColor.white
            //searchResults = songs
            //searchDict = songsDict
            // wordsSearchSection = wordsSection
            
            self.tableView.reloadData()
        }else {
            isTyping = true
            tableView.sectionIndexColor = UIColor.clear
            filterTableView(text: searchText)
            
        }
        
        if searchBar.text == nil || searchBar.text == ""
        {
            isTyping = false
            searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
        }
        
        
        
        
        
    }
    
    func filterTableView(text: String) {
        var ASEaarch = [MPMediaItem]()
        
        //var searchAppend = [Song]()
        var searchByName = [MPMediaItem]()
        searchByName = fullSongs.filter({ (mod) -> Bool in
            return (mod.title?.lowercased().contains(text.lowercased()))!
            
            
        })
        
        var searchByArtist = [MPMediaItem]()
        searchByArtist = fullSongs.filter({ (mod) -> Bool in
            
            
            
            
            
            
            return (mod.albumTitle?.lowercased().contains(text.lowercased()))!
            
        })
        if(!searchByName.isEmpty){
            ASEaarch += searchByName
        }
        
        if(!searchByArtist.isEmpty){
            ASEaarch += searchByArtist
        }
        //print(String(searchByName.count) + " *****" + String(searchByArtist.count) + " *****" + String(songSearch.count))
        
        
        print("The end is" + songSearch[songSearch.count-1].title!)
        songSearch = ASEaarch
        
        
        //fullSongs = searchAppend
        //search
        
        //searchAppend.removeAll()
        
        
        
        //self.tableView.reloadData()
        
        self.tableView.reloadData()
        
        
    }
    
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.frame.origin.y = max(0, scrollView.contentOffset.y)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isTyping){
            return songSearch.count
        }
        
        
        return playlistArray.count
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let tableHeaderView = tableView.tableHeaderView {
            tableView.bringSubview(toFront: tableHeaderView)
        }
    }
    
    func userDefaultsDidChange(_ notification: Notification) {
        
        
        
        tableView.reloadData()
        
        
        
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        //if(!isTyping){
            let cellIdentifier = "playlistTableCell"
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? playlistTableCell  else {
            fatalError("The dequeued cell is not an instance of playlistTableCell.")
            }
        
            // Fetches the appropriate meal for the data source layout.
            let aPlaylist = playlistArray[indexPath.row]
        
            cell.nameLabel.text = aPlaylist.name
            cell.photoImageView.image = aPlaylist.photo
        
            
            return cell
            /*
        }else {
            
            let cellIdentifier = "MealTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
                fatalError("The dequeued cell is not an instance of MealTableViewCell.")
            }
            //print("A " + String(describing: indexPath.last))
            //print("B " + String(songSearch.count))
            let aSong = songSearch[indexPath.row]
            //print(songSearch.count)
            
            self.tableView.rowHeight = 80
            /**
            cell.albumArt.image = aSong.albumArt
            cell.artistAlbumLabel.text = aSong.albumArtistName
            cell.songNameLabel.text = aSong.songName
            */
            
            
            
            
            
            
            
            //checks if artistname is empty
            if(aSong.artist != nil){
                cell.artistAlbumLabel.text = aSong.artist
                
            } else {
                cell.artistAlbumLabel.text = " "
            }
            //checks if albumart is empty
            if(aSong.artwork == nil){
                cell.albumArt.image = UIImage(named: "noArt")
            } else {
                cell.albumArt.image = aSong.artwork?.image(at: CGSize(width: 150, height: 150))
            }
            
            
            
            cell.songNameLabel.text = aSong.title
            
            
            
            
            return cell
        }
    */
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!isTyping){
            NSLog("You selected cell number: \(indexPath.row)!")
            
            tableView.deselectRow(at: indexPath, animated: true)
            thePlaylist = playlistArray[indexPath.row].songs
            selectedPlaylist = playlistArray[indexPath.row]
            loadSongs()
            performSegue(withIdentifier: "go", sender: indexPath)
        } else {
            NSLog("You selected cell number: \(indexPath.row)!")
            let theSong = songSearch[indexPath.row]
            //print(wordKey)
            
            self.searchBar.endEditing(true)
            self.searchBar.text = nil
            tableView.deselectRow(at: indexPath, animated: true)
            let player = MPMusicPlayerController.applicationMusicPlayer
            let mediaCollection = MPMediaItemCollection(items: [theSong])
            player.setQueue(with: mediaCollection)
            player.play()
            songSearch = fullSongs
            tableView.sectionIndexColor = UIColor.white
            //isTyping = false
            
        }
        isTyping = false
        tableView.reloadData()
        
        /**
         tableView.sectionIndexColor = UIColor.white
         searchDict = songsDict
         wordsSearchSection = wordsSection
         
         
         self.tableView.reloadData()
         */
        
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
        
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            
            
            let navController = segue.destination as! UINavigationController
            let detailController = navController.topViewController as! playlistTable!
            /**
            let dummySong = Song(songName: "String", albumArtistName: "String", albumArt: UIImage(), theSong: MPMediaItem(), albumTitle: "String")
            detailController?.songArr = [dummySong!]
            detailController?.songArr.removeAll()
           */
            
            detailController?.songArr = listOsongs
            detailController?.playlistImage = selectedPlaylist.photo
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    private func loadPlaylists() {
        
        let myPlaylistsQuery = MPMediaQuery.playlists()
        var playlists = myPlaylistsQuery.collections
        
        for playlist in playlists! {
           // print(playlist.value(forProperty: MPMediaPlaylistPropertyName) ?? "No name")
            // guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            //fatalError("Unable to instantiate meal1")
            
            let playlistName = playlist.value(forProperty: MPMediaPlaylistPropertyName)
            guard let aPlaylist = Playlist(name: playlistName as! String, photo: setImage(songs: playlist.items), songs: playlist.items) else {
                fatalError("Unable to instantiate")
            }
            playlistArray += [aPlaylist]
            
        }
        
        
        
        
        //meals += [meal1, meal2, meal3]
    }
    
    func setImage(songs: [MPMediaItem]) -> UIImage{
        var imageToReturn: UIImage
        let aNumber: Int
        
        
        if(songs.count != nil){
            aNumber = Int(arc4random_uniform(UInt32(songs.count)))
        } else {
            aNumber = 0
        }
        //guard let
        print(aNumber)
        //let aNumber = 0
        //print(aNumber)
        if(!songs.isEmpty && songs[aNumber].artwork != nil){
            imageToReturn = (songs[aNumber].artwork?.image(at: CGSize(width: 100, height: 100)))!
        } else {
            imageToReturn = #imageLiteral(resourceName: "noArtworkFound")
        }
        return imageToReturn
    }
    
    
    
    func loadSongs() {
        self.listOsongs.removeAll()
        
        listOsongs = thePlaylist!
        
        
        
    }
    
    func loadSearchSongs() {
        var allSongs = MPMediaQuery.songs().items
        songSearch = allSongs!
        fullSongs = allSongs!
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
}
