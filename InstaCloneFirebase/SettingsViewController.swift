//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Semafor on 23.09.2020.
//  Copyright © 2020 Semafor. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOutClicked(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Error")
        }
        
    }
    
}
