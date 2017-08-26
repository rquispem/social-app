//
//  SignInVC.swift
//  social-app
//
//  Created by Ruben Quispe Montoya on 8/25/17.
//  Copyright © 2017 rquispe. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    // this method cannot perform segues it is too early in the process
    override func viewDidLoad() {
        super.viewDidLoad()    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "FeedVC", sender: nil)
        }
    }


    @IBAction func fbButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (
            result, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Facebook - \(error!)")
            } else if result?.isCancelled == true {
                print("JESS: User cancelled Facebook authentication")
            } else {
                print("JESS: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    @IBOutlet weak var txtEmail: FancyField!
    @IBOutlet weak var txtPassword: FancyField!
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = txtEmail.text, let pass = txtPassword.text {
            Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error != nil {
                    Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                        if error != nil {
                            print("JESS: Unable to authenticate with Firebase using email")
                        } else {
                            self.completeSignIn(id: (user?.uid)!)
                            print("JESS: Successfully authenticated with Firebase")
                        }
                    })
                } else {
                    print("JESS: Successfully authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                    
                }
            })
        }
    }
    
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("JESS: Unable to authenticate with Firebase - \(error!)")
            } else {
                print("JESS: Successfully authenticated with Firebase")
                self.completeSignIn(id: (user?.uid)!)
            }
        }
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }

}
