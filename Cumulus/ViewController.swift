//
//  ViewController.swift
//  Cumulus
//
//  Created by Adam Cahall on 11/19/21.
//

import UIKit
import EventKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController {
    
    private var mainCollectionView: UICollectionView!
    private var homeButton = UIButton()
    private var settingsButton = UIButton()

    private var events: [Event] = [
//        Event(time: "9:30 AM - 10:30 AM", title: "CS 2110 Lecture", location: "Statler Hall"),
//        Event(time: "2:30 PM - 3:30 PM", title: "AppDev Design Critique", location: "Upson Hall")
    ]
    private var times: [[Int]] = [[]]
    private var weatherAtTimes: [Int:String] = [:]
    
    private let mainCellReuseIdentifier = "mainCellReuseIdentifier"
    private let mainHeaderReuseIdentifier = "mainHeaderReuseIdentifier"
    private let mainCellPadding: CGFloat = 10
    private let mainSectionPadding: CGFloat = 5
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkManager.getAllUsers { users in
//            print("working")
//            print(users)
//        }
//        NetworkManager.createUser(username: "test3", password: "testpassword", lat: 10, lon: 10, country_code: "US") { user in
//            DispatchQueue.main.async {
//                print(user)
//            }
//        }
        locationManager.delegate = self
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
        getNoficationAccess()
        createTestNotification()
        getLocation()
        getEvents()
        
        var eventsRefreshTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
        
        var locationRefreshTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        
//        var notificationTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(setUpNotifications), userInfo: nil, repeats: true)
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
    
    @objc func getLocation() {
        // https://www.advancedswift.com/user-location-in-swift/
        locationManager.requestAlwaysAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.locationServicesEnabled()) {
           currentLoc = locationManager.location
           print(currentLoc.coordinate.latitude)
           print(currentLoc.coordinate.longitude)
        }
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    func getNoficationAccess() {
        userNotificationCenter.requestAuthorization(options: [.alert]) { (granted, error) in
            if(!granted) {
                print("error")
            }
        }
    }
    
    func createTestNotification() {
        userNotificationCenter.delegate = self
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "testing"
        
        let date = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
//                                                        repeats: false)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        userNotificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
                // Something went wrong
            }
        })
        
        userNotificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(Date())
                print(request)
            }
        })
    }
    
    
    @objc func setUpNotifications() {
        userNotificationCenter.removeAllPendingNotificationRequests()
        for timePair in times {
            if(timePair != []) {
                var scheduledNotification = false
//                print("new event")
                var rangeOfTimes = (timePair[1] - timePair[0])/3600 + 2
                for i in 0...rangeOfTimes {
                    var hour = timePair[0] - 3600 + i * 3600
                    if(scheduledNotification == false /*and weather bad at hour*/) {
                        //schedule notification
                        scheduledNotification = true
                    }
                    
                }
//                print(rangeOfTimes)
            }
        }
    }
    func requestNotification() {
        
    }
    
    func sendNotification() {
        
    }
    
    let eventStore = EKEventStore()

    @objc func getEvents() {
        // https://developer.apple.com/documentation/eventkit/retrieving_events_and_reminders
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                var calendar = Calendar.current
////                var calendar = self.eventStore.defaultCalendarForNewEvents
//
//                // Create the start date components
//                var rightNowComponents = DateComponents()
//                rightNowComponents.day = 0
//                var rightNow = calendar.date(byAdding: rightNowComponents, to: Date(), wrappingComponents: false)
//
//                // Create the end date components.
                var oneDayFromNowComponents = DateComponents()
                oneDayFromNowComponents.day = 1
                var oneDayFromNow = calendar.date(byAdding: oneDayFromNowComponents, to: Date(), wrappingComponents: false)
                
                var current: Date? = Date()
                var endOfDay: Date? = Calendar.current.startOfDay(for: oneDayFromNow!)
//                print(current)
//                print(end)
                var userCalendars = self.eventStore.calendars(for: .event)
                
                for calendar in userCalendars {
                    // https://stackoverflow.com/questions/51439574/swift-4-how-to-get-all-events-from-calendar
                    // This checking will remove Birthdays and Hollidays callendars
                    if(calendar.allowsContentModifications) {
                        var predicate: NSPredicate? = nil
                        if let anAgo = current, let aNow = endOfDay {
                            predicate = self.eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
                        }

                        // Fetch all events that match the predicate.
                        var allEvents: [EKEvent]? = nil
                        if let aPredicate = predicate {
                            allEvents = self.eventStore.events(matching: aPredicate)
                            var userEvents = allEvents?.filter { $0.calendar.allowsContentModifications}
                            self.events = []
                            self.times = []
                            for event in userEvents ?? [] {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateStyle = .medium
                                dateFormatter.timeStyle = .none
                                dateFormatter.locale = Locale(identifier: "en_US")
                                dateFormatter.dateFormat = "h:mm a"
                                
                                var start = event.startDate as Date
                                var unixStart = Int(start.timeIntervalSince1970)
                                var formattedStart = dateFormatter.string(from: start)
                                
                                var end = event.endDate as Date
                                var unixEnd = Int(end.timeIntervalSince1970)
                                var formattedEnd = dateFormatter.string(from: end)
                                
                                var formattedTime = formattedStart + " - " + formattedEnd
                                
                                print(formattedTime)
                                
                                var title = event.title as String
                                
                                print(title)
                                
                                var location = (event.location ?? "") as String
                                
                                print(location)
                                print(unixStart)
                                print(unixEnd)
                                self.events.append(Event(time: formattedTime, title: title, location: location))
                                self.times.append([unixStart,unixEnd])
                            }
                            
                            DispatchQueue.main.async {
                                self.mainCollectionView.reloadData()
                            }
                        }
                    }
                    
                    // Create the predicate from the event store's instance method.
                }
            }
//            print(self.events)
//            print(self.times)
//            self.setUpNotifications()
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

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //https://stackoverflow.com/questions/42127403/how-do-i-handle-ios-push-notifications-when-the-app-is-in-the-foreground
            if UIApplication.shared.applicationState == .active {
                completionHandler( [.alert,.sound]) // completionHandler will show alert and sound from foreground app, just like a push that is shown from background app
            }
        }
}
    

