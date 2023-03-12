//
//  RootViewController.swift
//  Research-App
//
//  Created by Levi Harris on 2/25/23.
//

import UIKit
import FirebaseAuthUI
import FirebaseCore
import FirebaseFirestore

class RootViewController: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Root -> Feature.
        if Auth.auth().currentUser != nil {
            Navigation.changeRootViewControllerToFeature()
        }
    }
}
