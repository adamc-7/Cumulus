//
//  ViewController.swift
//  Cumulus
//
//  Created by Adam Cahall on 11/19/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var mainCollectionView: UICollectionView!
    private var homeButton = UIButton()
    private var settingsButton = UIButton()
    
    private let events: [Event] = [
        Event(time: "9:30 AM - 10:30 AM", title: "CS 2110 Lecture", location: "Statler Hall"),
        Event(time: "2:30 PM - 3:30 PM", title: "AppDev Design Critique", location: "Upson Hall")
    ]
    
    private let mainCellReuseIdentifier = "mainCellReuseIdentifier"
    private let mainHeaderReuseIdentifier = "mainHeaderReuseIdentifier"
    private let mainCellPadding: CGFloat = 10
    private let mainSectionPadding: CGFloat = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        title = "Events"
        view.backgroundColor = .white
        
        
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.minimumLineSpacing = mainCellPadding
        mainLayout.minimumInteritemSpacing = mainCellPadding
        mainLayout.scrollDirection = .vertical
        mainLayout.sectionInset = UIEdgeInsets(top: mainSectionPadding, left: 0, bottom: mainSectionPadding, right: 0)
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mainLayout)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.backgroundColor = .clear
        
        mainCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: mainCellReuseIdentifier)
        
        mainCollectionView.dataSource = self
        
        mainCollectionView.delegate = self
        
        
        view.addSubview(mainCollectionView)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("Edit Color", for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.backgroundColor = UIColor(red: 56/255, green: 61/255, blue: 68/255, alpha: 1)
        settingsButton.layer.cornerRadius = 4
        settingsButton.addTarget(self, action: #selector(presentViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(settingsButton)
        
        setupConstraints()
    }

    
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: collectionViewPadding),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewPadding),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: mainCollectionView.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            settingsButton.leadingAnchor.constraint(equalTo: mainCollectionView.leadingAnchor, constant: collectionViewPadding)
        ])
    }
    @objc func presentViewControllerButtonPressed() {
        let vc = SettingsViewController()
        present(vc, animated: true, completion: nil)
    }
    
}


extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        events.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCellReuseIdentifier, for: indexPath) as! CollectionViewCell
            cell.configure(for: events[indexPath.item])
            return cell
        }
        
    }
    

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 327, height: 125)
        
    }
}

    

