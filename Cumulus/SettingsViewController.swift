//
//  SettingsViewController.swift
//  Cumulus
//
//  Created by Teresa Huang on 11/21/21.
//

import UIKit

class SettingsViewController: UIViewController {
    var locationLabel = UILabel()
    var calendarLabel = UILabel()
    var displayLabel = UILabel()
    var notifLabel = UILabel()
    var updateLocButton = UIButton()
    var updateCalButton = UIButton()
    var homeButton = UIButton()
    var outButton = UIButton()
    var toggleButton = UISwitch(frame:CGRect(x: 300, y: 350, width: 72, height: 36))
    let darkBlue = UIColor(red: 0.073, green: 0.107, blue: 0.183, alpha: 1)
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
         appearance.configureWithTransparentBackground()
         appearance.titleTextAttributes = [.foregroundColor:darkBlue]
         navigationController?.navigationBar.standardAppearance = appearance
         navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
         title = "Settings"

        locationLabel.text = "Location:"
        locationLabel.textColor = darkBlue
        locationLabel.font = UIFont(name: "Roboto", size: 18)
        locationLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))

        locationLabel.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 700))
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)

        updateLocButton.setTitle("Update", for: .normal)
        updateLocButton.backgroundColor = darkBlue
        updateLocButton.layer.cornerRadius = 18
        updateLocButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateLocButton)
        
        calendarLabel.text = "Calendar:"
        calendarLabel.textColor = darkBlue
        calendarLabel.font = UIFont(name: "Roboto", size: 18)
        calendarLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 100))
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarLabel)
        
        updateCalButton.setTitle("Update", for: .normal)
        updateCalButton.backgroundColor = darkBlue
        updateCalButton.layer.cornerRadius = 18
        updateCalButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateCalButton)
        /*
        homeButton.setTitle("Home", for: .normal)
        homeButton.backgroundColor = darkBlue
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addSubview(homeButton)*/
        /*
        displayLabel.text = "Display"
        displayLabel.textColor = darkBlue
        displayLabel.font = UIFont(name: "Roboto", size: 18)
        displayLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)*/
        
        notifLabel.text = "Send Event Notifications"
        notifLabel.textColor = darkBlue
        notifLabel.font = UIFont(name: "Roboto", size: 18)
        notifLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        notifLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notifLabel)
        
        toggleButton.onTintColor = darkBlue
        view.addSubview(toggleButton)
        /*notifLabel.text = "Send Event Notifications"
        notifLabel.textColor = darkBlue
        notifLabel.font = UIFont(name: "Roboto", size: 18)
        notifLabel.font = .systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 700))
        notifLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notifLabel)*/

        outButton.setTitle("Sign Out", for: .normal)
        outButton.backgroundColor = darkBlue
        outButton.layer.cornerRadius = 18
        outButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(outButton)
        
        setUpContraints()
    }
    
    func setUpContraints() {
        /*NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])*/
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            updateLocButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
            updateLocButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
            updateLocButton.widthAnchor.constraint(equalToConstant: 108),
            updateLocButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            calendarLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 90),
            calendarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            updateCalButton.topAnchor.constraint(equalTo: updateLocButton.topAnchor, constant: 90),
            updateCalButton.trailingAnchor.constraint(equalTo: updateLocButton.trailingAnchor),
            updateCalButton.widthAnchor.constraint(equalToConstant: 108),
            updateCalButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        NSLayoutConstraint.activate([
            notifLabel.topAnchor.constraint(equalTo: calendarLabel.topAnchor, constant: 108),
            notifLabel.leadingAnchor.constraint(equalTo: calendarLabel.leadingAnchor)
        ])
        
        /*NSLayoutConstraint.activate([
            notifLabel.topAnchor.constraint(equalTo: notifLabel.topAnchor, constant: 72),
            notifLabel.leadingAnchor.constraint(equalTo: notifLabel.leadingAnchor)
        ])*/
        
        NSLayoutConstraint.activate([
            outButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            outButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            outButton.heightAnchor.constraint(equalToConstant: 36),
            outButton.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300),
            toggleButton.trailingAnchor.constraint(equalTo: updateCalButton.trailingAnchor)
            
        ])
    
     
        
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
