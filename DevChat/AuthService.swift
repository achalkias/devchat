//
//  AuthService.swift
//  DevChat
//
//  Created by Apostolos Chalkias on 08/08/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

class AuthService {
    
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    
    func login(email: String, password: String,onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password) { (
            user, error) in
            //Check for error
            if error != nil {
                //Get the error
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == AuthErrorCode.userNotFound {
                        //User not found in database. Ask the user to create an account
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (
                            user, error) in
                            //Check for error
                            if error != nil {
                                //Show error to user
                                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            } else {
                                
                                //Add user to firebase database
                                DataService.instance.saveUser(uid: user!.uid)
                                
                                if user?.uid != nil {
                                    //Sign in
                                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                        if error != nil {
                                            //Show error to user
                                        
                                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                                        } else {
                                            //Successfully logged in
                                            onComplete?(nil,user)
                                        }
                                    })
                                }
                            }
                        })
                    }
                } else {
                    //Handle all other errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully logged in
                onComplete?(nil,user)
            }
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    
}
