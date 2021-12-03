//
//  MainViewController.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/3/21.
//

import UIKit

class MainViewController: UIViewController {
    

        
    override func viewDidLoad() {
        super.viewDidLoad()
        var vc: UIViewController
        if(UserDefaults.standard.bool(forKey: "isLoggedIn") == nil) {
            vc = SignUpViewController()
        }
        
        else if(UserDefaults.standard.bool(forKey: "isLoggedIn") == false) {
            vc = SignUpViewController()
        }
        
        else {
            vc = SignUpViewController()
        }
        
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
