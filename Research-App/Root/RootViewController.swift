//
//  RootViewController.swift
//  Research-App
//
//  Created by Levi Harris on 2/25/23.
//

import UIKit
import FirebaseAuthUI

class RootViewController: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User successfully logged in.
        if Auth.auth().currentUser != nil {
            
            let feature = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeatureViewController") as! FeatureViewController
            
            UIWindowScene.windows.first?.rootViewController = feature
            UIWindowScene.windows.first?.makeKeyAndVisible()
            print("Pre-Exisiting User")
        }
    }
}
