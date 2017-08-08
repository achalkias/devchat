//
//  UsersVC.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    
    private var selectedUsers = Dictionary<String,User>()
    
    private var _snapData: Data?
    
    private var _videoUrl: URL?
    
    var snapData: Data? {
        set {
            _snapData = newValue
        } get {
           return _snapData
        }
    }
    
    var videoUrl: URL?{
        set {
            _videoUrl = newValue
        } get {
            return _videoUrl
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        //Disable the sendButon
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        //Create a firbease database reference to get the users
        DataService.instance.usersRef.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            
            //Parse Data from firebase
            if let users = snapshot.value as? Dictionary<String,Any> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String,Any> {
                        if let profile = dict["profile"] as? Dictionary<String,Any> {
                            if let firstname = profile["firstname"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstname: firstname)
                                self.users.append(user)
                            }
                        }
                    }
                }
                //Reload data of the table view
                self.tableView.reloadData()
                print("users: \(self.users)")
            }
            
        }
        
    }

    // MARK: TableView functions
    //--------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        //Set user
        let user = users[indexPath.row]
        //Update cell with user data
        cell.updateUI(user: user)
        //Return cell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Enable the sendButon
        navigationItem.rightBarButtonItem?.isEnabled = true
        //Get cell
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        //call setcheck mark and set it true
        cell.setCheckMark(selected: true)
        //Get selected user
        let user = users[indexPath.row]
        //Add user to selected users dictionary
        selectedUsers[user.uid] = user
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //Get cell
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        //call setcheck mark and set it false
        cell.setCheckMark(selected: false)
        //Get selected user
        let user = users[indexPath.row]
        //Rmove user to selected users dictionary
        selectedUsers[user.uid] = nil
        
        if selectedUsers.count <= 0 {
            //Disable the sendButon
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @IBAction func sendPRBtnPressed(sender: AnyObject) {
        
        //Check if there is a videoUrl
        if let url = _videoUrl {
            //Create a unique video name
            let videoName = "\(NSUUID().uuidString)\(url)"
            //Add it to the refernce
            let ref = DataService.instance.videoStorageRef.child(videoName)
            
            print("Starting video upload")
            
            _ = ref.putFile(from: url, metadata: nil, completion: { (
                meta, err) in
                if err != nil {
                    print("Error uploading video: \(err!.localizedDescription)")
                } else {
                    
                    //Get the download url from firebase
                    let downloadUrl = meta!.downloadURL()
                    print("Download URL: \(downloadUrl)")
                    
                    //Send it to users
                    DataService.instance.sendMediaPullRequest(senderUID: (Auth.auth().currentUser?.uid)!, sendingTo: self.selectedUsers, mediaURL: downloadUrl!, textSnippet: "Coding today was Legit")
                    
                    
                }

            })
            //Close controller
            self.dismiss(animated: true, completion: nil)
        } else if let snap = _snapData {
            let ref = DataService.instance.imageStorageRef.child("\(NSUUID().uuidString).jpg")
            
            _ = ref.putData(snap, metadata: nil, completion: { (meta:StorageMetadata?, err:Error?) in
                if err != nil {
                    print("Error uploading snapshot: \(err!.localizedDescription)")
                } else {
             //       let downloadURL = meta!.downloadURL()
                    self.dismiss(animated: true, completion: nil)
                }
            })
            //            _ = ref.put(snap, metadata: nil, completion: { (meta:FIRStorageMetadata?, err:NSError?) in
            //
            //                if err != nil {
            //                    print("Error uploading snapshot: \(err?.localizedDescription)")
            //                } else {
            //                    let downloadURL = meta!.downloadURL()
            //                    self.dismiss(animated: true, completion: nil)
            //                }
            //            })
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
        
        
        
    }
    
   
 
}
