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

// this is view controller for the main home page of the app
// *** note that there is a bug where the settings button will not be displayed on initial login to app,
// you will see it if you relaunch the program after initially logging in ***

class ViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private var mainCollectionView: UICollectionView!
    private var homeButton = UIButton()
    private var settingsImage = UIImage(named: "SettingsImage")?.withRenderingMode(.alwaysTemplate)
    private var eventsLabel = UILabel()
    let darkBlue = UIColor(red: 0.073, green: 0.107, blue: 0.183, alpha: 1)
    var welcomeLabel = UILabel()
    var descriptionImage = UIImageView()
    var descriptionLabel = UILabel()
    var tempLabel = UILabel()
    let backImage = UIImageView()
    
    // events stores all of the events that start anytime from right now to the end of the day
    private var events: [Event] = []
    // times stores the start and end time for all events that start anytime from right now to the end of the day in the form [ [startTime1, endTime1], [startTime2, endTime2], ...etc]
    private var times: [[Int]] = [[]]
    
    private var weatherAtTimes: [Int:String] = [:]
    
    private let mainCellReuseIdentifier = "mainCellReuseIdentifier"
    private let mainHeaderReuseIdentifier = "mainHeaderReuseIdentifier"
    private let mainCellPadding: CGFloat = 10
    private let mainSectionPadding: CGFloat = 5
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backImage.image = UIImage(named: "sunny")
        backImage.contentMode = .scaleAspectFill
        backImage.clipsToBounds = true
        backImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backImage)
        
        let settingsButton = UIBarButtonItem(image: settingsImage , style: .plain, target: self, action: #selector(ViewController.pushViewControllerButtonPressed))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: darkBlue]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.topItem?.rightBarButtonItem = settingsButton
        
        locationManager.delegate = self
        
        let mainLayout = UICollectionViewFlowLayout()
        mainLayout.minimumLineSpacing = mainCellPadding
        mainLayout.minimumInteritemSpacing = mainCellPadding
        mainLayout.scrollDirection = .vertical
        mainLayout.sectionInset = UIEdgeInsets(top: mainSectionPadding, left: 0, bottom: mainSectionPadding, right: 0)

        welcomeLabel.text = "Hi there! Let's take a look at your day."
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont(name: "Comfortaa-Bold", size: 40)
        welcomeLabel.font = .systemFont(ofSize: 40)
        welcomeLabel.lineBreakMode = .byWordWrapping
        welcomeLabel.numberOfLines = 0
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mainLayout)
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.backgroundColor = .clear
        mainCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: mainCellReuseIdentifier)
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        view.addSubview(mainCollectionView)
        
        eventsLabel.text = "Events for today:"
        eventsLabel.font = UIFont(name: "Roboto", size: 15)
        eventsLabel.textColor = .white
        eventsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventsLabel)
        
        descriptionImage.image = UIImage(named: "Clouds")
        descriptionImage.clipsToBounds = true
        descriptionImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionImage)
        
        descriptionLabel.text = "Current Temperature:"
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // placeholder for now, would show actual temperature when integrated with backend
        tempLabel.text = "36°F"
        tempLabel.font = UIFont(name: "Comfortaa-Bold", size: 50)
        tempLabel.font = .systemFont(ofSize: 50)
        tempLabel.textColor = .white
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tempLabel)
        
        // initial checks
        getNoficationAccess()
        getLocation()
        getEvents()
        setUpNotifications()
        
        // checks for new scheduled events every 20 seconds and updates events array
        var eventsRefreshTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
        
        // updates location every 20 seconds
        var locationRefreshTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getLocation), userInfo: nil, repeats: true)
        
        // updates notifications every 20 seconds using new event and location information
        var notificationTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(setUpNotifications), userInfo: nil, repeats: true)
        
        setupConstraints()
        
        // Does not work, but this is an example of how weather would be fetched from backend.
        // See NetworkManager for other functions that connect/attempt to connect to backend that are not currently being implemented.
        NetworkManager.getWeather(token: UserDefaults.standard.string(forKey: "session_token")!) { weather in
            print(weather)
        }
    }

    
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 12
        
        NSLayoutConstraint.activate([
                 backImage.topAnchor.constraint(equalTo: view.topAnchor),
                   backImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                   backImage.heightAnchor.constraint(equalTo: view.heightAnchor)
                ])
                
                NSLayoutConstraint.activate([
                    mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 416),
                    mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
                    mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewPadding),
                    mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
                ])
                
                NSLayoutConstraint.activate([
                    eventsLabel.topAnchor.constraint(equalTo: mainCollectionView.topAnchor, constant: -30),
                    eventsLabel.leadingAnchor.constraint(equalTo: mainCollectionView.leadingAnchor, constant: 12)
                ])
                
                NSLayoutConstraint.activate([
                    welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),
                    welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                    welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
                ])
                NSLayoutConstraint.activate([
                    descriptionImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    descriptionImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 230)
                ])
                
                NSLayoutConstraint.activate([
                    descriptionLabel.leadingAnchor.constraint(equalTo: descriptionImage.trailingAnchor, constant: 10),
                    descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 235)
                ])

                NSLayoutConstraint.activate([
                    tempLabel.leadingAnchor.constraint(equalTo: descriptionImage.leadingAnchor),
                    tempLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20)
                ])
    }
    
    // shows settings view when called by settings button on touch
    @objc func pushViewControllerButtonPressed() {
        let vc = SettingsViewController()
        
        vc.navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // gets user's location, which would be used in requests to backend
    @objc func getLocation() {
        // Source: https://www.advancedswift.com/user-location-in-swift/
        locationManager.requestAlwaysAuthorization()
        var currentLocation: CLLocation!
        if(CLLocationManager.locationServicesEnabled()) {
           currentLocation = locationManager.location
//           print(currentLoc.coordinate.latitude)
//           print(currentLoc.coordinate.longitude)
        }
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    //
    func getNoficationAccess() {
        userNotificationCenter.requestAuthorization(options: [.alert]) { (granted, error) in
            if(!granted) {
                print("error")
            }
        }
    }
    
    // not being used but will properly display a notification if called
    func createTestNotification() {
        userNotificationCenter.delegate = self
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "testing"
        

        let date = Date(timeIntervalSince1970: TimeInterval(1638560000))
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        userNotificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
        
        userNotificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(Date())
                print(request)
            }
        })
    }
    
    // Sends
    @objc func setUpNotifications() {
        userNotificationCenter.removeAllPendingNotificationRequests()
        for timePair in times {
            if(timePair != []) {
                var scheduledNotification = false
                var rangeOfTimes = (timePair[1] - timePair[0])/3600 + 2
                
                // - The following loop goes through each hour in range of times [1 hour before event, 1 hour after event].
                // - For each time, checks if a notification has already been scheduled for the event
                // and if not it will schedule a notification to be sent an hour before the event.
                // - Would also check if weather was bad in order to decide whether or not to schedule
                // a notification if backend was implemented.
                for i in 0...rangeOfTimes {
                    var hour = timePair[0] - 3600 + i * 3600
                    if(scheduledNotification == false /* and weather bad at hour (if backend was implemented) */) {
                        scheduledNotification = true
                        userNotificationCenter.delegate = self
                        let content = UNMutableNotificationContent()
                        content.title = "Test Notification"
                        content.body = "testing"
                        
                        let date = Date(timeIntervalSince1970: TimeInterval(timePair[0]) - 3600)
                        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                
                        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                        
                        let identifier = "UYLLocalNotification"
                        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                        userNotificationCenter.add(request, withCompletionHandler: { (error) in
                            if let error = error {
                                print(error)
                            }
                        })
                        
                        userNotificationCenter.getPendingNotificationRequests(completionHandler: { requests in
                            for request in requests {
                                print(Date())
                                print(request)
                            }
                        })
                    }
                }
            }
        }
    }
    
    let eventStore = EKEventStore()

    @objc func getEvents() {
        // Source: https://developer.apple.com/documentation/eventkit/retrieving_events_and_reminders
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                var calendar = Calendar.current

                var oneDayFromNowComponents = DateComponents()
                oneDayFromNowComponents.day = 1
                var oneDayFromNow = calendar.date(byAdding: oneDayFromNowComponents, to: Date(), wrappingComponents: false)
                
                // time right now
                var current: Date? = Date()
                // today at midnight
                var endOfDay: Date? = Calendar.current.startOfDay(for: oneDayFromNow!)
                
                var userCalendars = self.eventStore.calendars(for: .event)
                
                for calendar in userCalendars {
                    // Source: https://stackoverflow.com/questions/51439574/swift-4-how-to-get-all-events-from-calendar
                    // Removes birthday and holiday calendars
                    if(calendar.allowsContentModifications) {
                        var predicate: NSPredicate? = nil
                        if let anAgo = current, let aNow = endOfDay {
                            predicate = self.eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
                        }

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
                            
                            // updates collection view with new events
                            DispatchQueue.main.async {
                                self.mainCollectionView.reloadData()
                            }
                        }
                    }
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

// allows notifications to be shown while app is in foreground
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    // Source: https://stackoverflow.com/questions/42127403/how-do-i-handle-ios-push-notifications-when-the-app-is-in-the-foreground
            if UIApplication.shared.applicationState == .active {
                completionHandler( [.alert,.sound])
            }
        }
}

