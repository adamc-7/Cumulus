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
    var homeButton = UIButton()
    
    
    override func viewDidLoad() {
        locationLabel.text = "Location:\nIthaca, NY"
        calendarLabel.text = "Calendar:\nGoogle Calendar"
        homeButton.setTitle("Home", for: .normal)
        setUpContraints()
    }
    
    func setUpContraints() {
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            calendarLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 20),
            calendarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
     
        
    }
}
