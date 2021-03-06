//
//  LoginViewController.swift
//  Cumulus
//
//  Created by Teresa Huang on 12/3/21.
//

import UIKit

// What is shown when you first launch app. Would also be shown when sign out button is touched if its functionality was implemented.
class SignUpViewController: UIViewController {
    
    var nameField = UITextField()
    var password = UITextField()
    var signButton = UIButton()
    var logButton = UIButton()
    var logoImage = UIImageView()
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        logoImage.image = UIImage(named: "LogInImage")
        logoImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFill
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
                
        nameField.placeholder = "   Name"
        nameField.backgroundColor = .lightGray
        nameField.font = .systemFont(ofSize: 15)
        nameField.layer.cornerRadius = 15
        nameField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameField)
                
        password.placeholder = "    Password"
        password.font = .systemFont(ofSize: 15)
        password.backgroundColor = .lightGray
        password.layer.cornerRadius = 15
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
        
        logButton.addTarget(self, action: #selector(logButtonPressed), for: .touchUpInside)
        
        setUpConstraints()
        
    }
    // creates an account for the user and brings them to main home page, also stores their session token and their login status (true) in userDefaults
    @objc func signButtonPressed() {
        print(nameField.text)
        print(password.text)
        NetworkManager.createUser(username: nameField.text ?? "", password: password.text ?? "", lat: 10, lon: 10, country_code: "US") { user in
            DispatchQueue.main.async {
                print(user.session_token)
                UserDefaults.standard.set(user.session_token, forKey: "session_token")
            }
        }
        UserDefaults.standard.set(true, forKey: "isLoggedIn")

        let vc = ViewController()
        
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // not sure if this actually works but it theoretically should if loginUser function in NetworkManager works properly
    @objc func logButtonPressed() {
        print(nameField.text)
        print(password.text)
        
        NetworkManager.loginUser(username: nameField.text ?? "", password: password.text ?? "") { user in
            UserDefaults.standard.set(user.session_token, forKey: "session_token")
            print(UserDefaults.standard.string(forKey: "session_token"))
        }
        UserDefaults.standard.set(true, forKey: "isLoggedIn")

        let vc = ViewController()
        var settingsImage = UIImage(named: "SettingsImage")?.withRenderingMode(.alwaysTemplate)
        let settingsButton = UIBarButtonItem(image: settingsImage , style: .plain, target: self, action: #selector(ViewController.pushViewControllerButtonPressed))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        vc.navigationController?.navigationBar.standardAppearance = appearance
        vc.navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        vc.navigationController?.navigationBar.topItem?.rightBarButtonItem = settingsButton
        vc.navigationController?.isNavigationBarHidden = false
        vc.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setUpConstraints() {
           NSLayoutConstraint.activate([
               logoImage.topAnchor.constraint(equalTo: view.topAnchor),
               logoImage.widthAnchor.constraint(equalTo: view.widthAnchor),
               logoImage.heightAnchor.constraint(equalToConstant: 375)
           ])
           
           NSLayoutConstraint.activate([
               nameField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 40),
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
               signButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
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
