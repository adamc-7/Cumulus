//
//  Calendar.swift
//  Cumulus
//
//  Created by Adam Cahall on 12/1/21.
//

import Foundation
import EventKit

let eventStore = EKEventStore()

func requestAccess() {
    eventStore.requestAccess(to: .event) { (granted, error) in
        if granted {
//            var events: [EKEvent]? = nil
//            events = eventStore.events(matching: <#T##NSPredicate#>)
            // Get the appropriate calendar.
            var calendar = Calendar.current

            // Create the start date components
            var oneDayAgoComponents = DateComponents()
            oneDayAgoComponents.day = -1
            var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date(), wrappingComponents: false)

            // Create the end date components.
            var oneYearFromNowComponents = DateComponents()
            oneYearFromNowComponents.year = 1
            var oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date(), wrappingComponents: false)

            // Create the predicate from the event store's instance method.
            var predicate: NSPredicate? = nil
            if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
                predicate = eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
            }

            // Fetch all events that match the predicate.
            var events: [EKEvent]? = nil
            if let aPredicate = predicate {
                events = eventStore.events(matching: aPredicate)
            }
            print(events)
        }
    }
}
