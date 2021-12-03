//
//  LoginViewController.swift
//  Cumulus
//
//  Created by Teresa Huang on 12/3/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var nameField = UITextField()
    var password = UITextField()
    var signButton = UIButton()
    var logButton = UIButton()
    var logoImage = UIImageView()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        logoImage.image = UIImage(named: "LogInImage")
        logoImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFill
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        
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
        
        signButton.addTarget(self, action: #selector(signButtonPressed), for: .touchUpInside)
        
        logButton.setTitle("Log In", for: .normal)
        logButton.backgroundColor = .lightGray
        logButton.layer.cornerRadius = 15
        logButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logButton)
        
        setUpConstraints()
        
    }
    
    @objc func signButtonPressed() {
        
    }
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.topAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 375)
        ])
        
        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 90),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.widthAnchor.constraint(equalToConstant: 327),
            nameField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 30),
            password.centerXAnchor.constraint(equalTo: nameField.centerXAnchor),
            password.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            password.heightAnchor.constraint(equalTo: nameField.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signButton.topAnchor.constraint(equalTo: logoImage.bottomAnchor),
            signButton.widthAnchor.constraint(equalToConstant: 150),
            signButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            logButton.leadingAnchor.constraint(equalTo: signButton.trailingAnchor, constant: 24),
            logButton.topAnchor.constraint(equalTo: signButton.topAnchor),
            logButton.widthAnchor.constraint(equalTo: signButton.widthAnchor),
            logButton.heightAnchor.constraint(equalTo: signButton.heightAnchor)
        ])
        
        
    }
}

