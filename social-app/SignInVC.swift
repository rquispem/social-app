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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            print("JESS: Successfully authenticated with Firebase")
                        }
                    })
                } else {
                    print("JESS: Successfully authenticated with Firebase")
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
            }
        }
    }

}
