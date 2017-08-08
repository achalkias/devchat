//
//  CameraVC.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import FirebaseAuth

class CameraVC: AAPLCameraViewController, AAPLCameraVCDelegate {

    @IBOutlet weak var previewView: AAPLPreviewView!
    
    @IBOutlet weak var cameraBtn: UIButton!
    
    @IBOutlet weak var recordBtn: UIButton!
    
    
    override func viewDidLoad() {
        self._previewView = previewView
        super.viewDidLoad()
        
       delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       // performSegue(withIdentifier: "LoginVC", sender: nil)
        
        //Check if the user is logged in to open the login vc
        guard Auth.auth().currentUser != nil else {
            performSegue(withIdentifier: "LoginVC", sender: nil)
            return
        }
    }


    @IBAction func recordBtnPressed(_ sender: Any) {
        self.toggleMovieRecording()
       
    }
  
    
    @IBAction func changeCammeraPressed(_ sender: Any) {
        self.changeCamera()
    }
    
    func shouldEnableCameraUI(_ enable: Bool) {
        cameraBtn.isEnabled = enable
         print("Should enable camera UI: \(enable)")
    }
    
    func shouldEnableRecordUI(_ enable: Bool) {
        recordBtn.isEnabled = enable
        print("Should enable record UI: \(enable)")
    }
    
    func recordingHasStarted() {
        print("Recording has started")
    }
    
    func canStartRecording() {
         print("Can start recording")
    }
    
    func videoRecordingFailed() {
        
    }
    
    func videoRecordingComplete(_ videoURL: URL!) {
        performSegue(withIdentifier: "UsersVC", sender: ["videoURL":videoURL])
    }
    
    func snapshotFailed() {
        
    }
    
    func snapshotTaken(_ snapshotData: Data!) {
        performSegue(withIdentifier: "UsersVC", sender: ["snapshotData": snapshotData])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepeare for segue")
        
        //Pass data to next controller
        if let usersvc = segue.destination as? UsersVC {
            if let videoDict = sender as? Dictionary<String, URL> {
                //Get the video url
                let url = videoDict["videoURL"]
                //Pass it to next view controller
            
                usersvc.videoUrl = url
            } else if let snapDict = sender as? Dictionary<String, Data> {
                //Get the image data
                let snapData = snapDict["snapshotData"]
                //Pass it to next view controller
                usersvc.snapData = snapData
            }
        }
    }
    

    
}

