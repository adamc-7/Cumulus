//
//  LoginViewController.swift
//  Cumulus
//
//  Created by Teresa Huang on 12/3/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var nameField = UITextField()
    var phoneField = UITextField()
    var password = UITextField()
    var signButton = UIButton()
    var logButton = UIButton()
    
    override func viewDidLoad() {
        nameField.placeholder = "Name"
        nameField.tintColor = .lightGray
        nameField.font = .systemFont(ofSize: 15)
        nameField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpConstraints() {
        
    }
}

