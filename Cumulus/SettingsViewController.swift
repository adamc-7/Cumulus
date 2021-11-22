//
//  SettingsViewController.swift
//  Cumulus
//
//  Created by Teresa Huang on 11/21/21.
//

import UIKit

class SettingsViewController: UIViewController {
    var label = UILabel()
    
    override func viewDidLoad() {
        label.text = "hi"
        view.addSubview(label)
        setUpContraints()
    }
    
    func setUpContraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
}
