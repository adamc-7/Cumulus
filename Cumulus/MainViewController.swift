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
        if(UserDefaults.standard.string(forKey: "isLoggedIn") == nil) {
                let vc = ViewController()
                
//                vc.navigationController?.isNavigationBarHidden = false
                navigationController?.pushViewController(vc, animated: true)
        }
        
        

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
