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
        view.backgroundColor = .white
        locationLabel.text = "Location:"
        locationLabel.textColor = .black
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarLabel.text = "Calendar:"
        calendarLabel.textColor = .black
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setTitle("Home", for: .normal)
        homeButton.backgroundColor = .black
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addSubview(locationLabel)
        view.addSubview(calendarLabel)
        view.addSubview(homeButton)
        setUpContraints()
    }
    
    func setUpContraints() {
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        NSLayoutConstraint.activate([
            calendarLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 30),
            calendarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
     
        
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
