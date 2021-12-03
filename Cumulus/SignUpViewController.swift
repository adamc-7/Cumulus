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
    var logoImage = UIImageView()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        nameField.placeholder = "Name"
        nameField.tintColor = .lightGray
        nameField.font = .systemFont(ofSize: 15)
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
        
        password.placeholder = "Password"
        password.tintColor = .lightGray
        password.font = .systemFont(ofSize: 15)
        password.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(password)
        
        signButton.setTitle("Sign Up", for: .normal)
        signButton.backgroundColor = .lightGray
        signButton.layer.cornerRadius = 15
        signButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signButton)
        
        logButton.setTitle("Log In", for: .normal)
        logButton.backgroundColor = .lightGray
        logButton.layer.cornerRadius = 15
        logButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logButton)
        
        setUpConstraints()
        
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            logButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

