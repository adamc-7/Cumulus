//
//  MainViewController.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/3/21.
//

import UIKit

// this controls which screen is displayed when the app is opened depending on the user's login status
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var vc: UIViewController
        
        // has never logged in
        if(UserDefaults.standard.bool(forKey: "isLoggedIn") == nil) {
            vc = SignUpViewController()
        }
        
        // is currently logged out
        else if(UserDefaults.standard.bool(forKey: "isLoggedIn") == false) {
            vc = SignUpViewController()
        }
        
        // is currently logged in
        else {
            vc = ViewController()
        }
        
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}
