//
//  FeedVC.swift
//  social-app
//
//  Created by Ruben Quispe Montoya on 8/26/17.
//  Copyright © 2017 rquispe. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutTapped(_ sender: Any) {
        // 1. delete keychain
        //2. delete firebase session
        do {
            try Auth.auth().signOut()
            print("JESS: Successfully signed out from firebase")
            
        } catch {
            print("JESS: An error ocurred when tried to logout firebase")
        }
        
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful {
            print("JESS: Successfuly removed keychain")
            performSegue(withIdentifier: "goToLogin", sender: nil)
        }
    }
}
