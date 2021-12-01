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
    var summaryLabel = UILabel()
    var notifLabel = UILabel()
    var homeButton = UIButton()
    let darkBlue = UIColor(red: 0.073, green: 0.107, blue: 0.183, alpha: 1)
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        locationLabel.text = "Location:"
        locationLabel.textColor = darkBlue
        locationLabel.font = UIFont
        locationLabel.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 700))
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)

        calendarLabel.text = "Calendar:"
        calendarLabel.textColor = darkBlue
        calendarLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarLabel)
        
        homeButton.setTitle("Home", for: .normal)
        homeButton.backgroundColor = darkBlue
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        view.addSubview(homeButton)
        
        displayLabel.text = "Display"
        displayLabel.textColor = darkBlue
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displayLabel)
        
        summaryLabel.text = "Send Morning Summary"
        summaryLabel.textColor = darkBlue
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryLabel)
        
        notifLabel.text = "Send Event Notifications"
        notifLabel.textColor = darkBlue
        notifLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notifLabel)

        
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
