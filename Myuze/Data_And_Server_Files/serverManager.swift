//
//  serverManager.swift
//  myuzicBackground
//
//  Created by Arya Mirshafii on 12/18/17.
//  Copyright © 2017 Arya Mirshafii. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

class serverManager: NSObject, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var stringURL:String = "http://192.168.0.13:3000/tasks/"
    var dataController = dataManager()
    func checkLocation() -> String{
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let newLatitude:Int = Int(floor((locationManager.location?.coordinate.latitude)! * 1000))
        let newLongitude:Int = Int(floor((locationManager.location?.coordinate.longitude)! * 1000))
        print(String(newLatitude) + String(newLongitude))
        return String(newLatitude) + String(newLongitude)
    }
    
    
    func put(objectID:String, songtoAdd: String){
        var urlString = stringURL + objectID
        var previousSong:String = ""
        var previousLocation:String = ""
        Alamofire.request(urlString).responseJSON { response in
            debugPrint("All Response Info: \(response)")
            if let data = response.result.value {
                let json = JSON(data)
                previousSong = json.dictionaryObject!["songList"] as! String
                previousLocation = json.dictionaryObject!["locationName"] as! String
                var songArray = [String]()
                songArray.append(previousSong)
                songArray.append(songtoAdd)
                
                //let params = [ "songList": previousSong + " @" +  songtoAdd,"locationName": previousLocation] as [String : Any]
                let params = [ "songList": songArray,"locationName": previousLocation] as [String : Any]
                Alamofire.request(urlString, method: .put, parameters: params, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        debugPrint(response)
                        print("it worked!!!")
                }
            }
        }
        
    }
    
    
    
    
    func postData(locationID:String, songtoAdd: String){
        
        let parameters = [ "locationName":  locationID ,"songList": songtoAdd] as [String : Any]
        
        //create the url with URL
        let url = URL(string: stringURL)! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    print("DATA POSTED")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    
    
    func saveToCoreData(){
        
        Alamofire.request(stringURL).responseJSON { response in
            
            if let json = response.result.value {
                print(json)                        // get your json response
            }
            if let myData = response.data  {
                
                do {
                    
                    let myJason = try JSON(data: myData)
                    if(!myJason.isEmpty){
                        let myID = myJason[myJason.count - 1].dictionary!["_id"]?.string
                        
                        let locationName = myJason[myJason.count - 1]["locationName"].string
                        
                        self.dataController.saveData(objectID: String(describing: myID!) , locationID: String(locationName!))
                    }
                } catch {
                    print("error has happened")
                }
            }
        }
    }
}
