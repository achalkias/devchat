//
//  DataService.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//


let FIR_CHILD_USERS = "users"


import Foundation
import FirebaseDatabase
import FirebaseStorage

class DataService {

    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var usersRef: DatabaseReference {
        return mainRef.child(FIR_CHILD_USERS)
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://devchat-52971.appspot.com")
    }
    
    var imageStorageRef: StorageReference {
        return  mainStorageRef.child("images")
    }
    
    var videoStorageRef: StorageReference {
        return  mainStorageRef.child("videos")
    }
    
    func saveUser(uid: String) {
        let profile: Dictionary<String,Any> = ["firstname":"","lastname":""]
        mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo:Dictionary<String, User>, mediaURL: URL, textSnippet: String? = nil) {
        
        //Get the reciptients uids
        var uids = [String]()
        for uid in sendingTo.keys {
            uids.append(uid)
        }
        
        //Create a pull request
        let pr: Dictionary<String, AnyObject> = ["mediaURL":mediaURL.absoluteString as AnyObject, "userID":senderUID as AnyObject,"openCount": 0 as AnyObject, "recipients":uids as AnyObject]
        
        //Add it to refernce
        mainRef.child("pullRequests").childByAutoId().setValue(pr)
        
    }
    
}
