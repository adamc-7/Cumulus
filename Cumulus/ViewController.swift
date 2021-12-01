//
//  ViewController.swift
//  Cumulus
//
//  Created by Adam Cahall on 11/19/21.
//

import UIKit
import EventKit

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
        
       // let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        //appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        //navigationController?.navigationBar.standardAppearance = appearance
        //navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        //title = "Events"
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
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.backgroundColor = UIColor(red: 56/255, green: 61/255, blue: 68/255, alpha: 1)
        settingsButton.layer.cornerRadius = 4
        settingsButton.addTarget(self, action: #selector(presentViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(settingsButton)
       // self.modalPresentationStyle = .overFullScreen
        getEvents()
        var eventsRefreshTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)

//        requestAccess()
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
            settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 331)
        ])
    }
    @objc func presentViewControllerButtonPressed() {
        let vc = SettingsViewController()
        present(vc, animated: true, completion: nil)
    }
    
    let eventStore = EKEventStore()

    @objc func getEvents() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                var calendar = Calendar.current
//                var calendar = self.eventStore.defaultCalendarForNewEvents
                
                // Create the start date components
                var oneDayAgoComponents = DateComponents()
                oneDayAgoComponents.day = -1
                var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)

                // Create the end date components.
                var oneDayFromNowComponents = DateComponents()
                oneDayFromNowComponents.year = 1
                var oneDayFromNow = calendar.date(byAdding: oneDayFromNowComponents, to: Date(), wrappingComponents: false)
                var userCalendars = self.eventStore.calendars(for: .event)
                for calendar in userCalendars {
                    // This checking will remove Birthdays and Hollidays callendars
                    if(calendar.allowsContentModifications) {
                        var predicate: NSPredicate? = nil
                        if let anAgo = oneDayAgo, let aNow = oneDayFromNow {
                            predicate = self.eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
                        }

                        // Fetch all events that match the predicate.
                        var events: [EKEvent]? = nil
                        if let aPredicate = predicate {
                            events = self.eventStore.events(matching: aPredicate)
                            var userEvents = events?.filter { $0.calendar.allowsContentModifications}
                            for event in userEvents ?? [] {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateStyle = .medium
                                dateFormatter.timeStyle = .none
                                dateFormatter.locale = Locale(identifier: "en_US")
                                
                                var start = event.startDate as Date
                                print(start as Date)
                                print(dateFormatter.string(from: start))
                            }
                        }
                    }
                    // Create the predicate from the event store's instance method.
                }
            }
        }
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

    

