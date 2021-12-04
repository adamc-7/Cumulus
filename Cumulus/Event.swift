//
//  Event.swift
//  Cumulus
//
//  Created by Adam Cahall on 11/21/21.
//

import Foundation

// class for an event from the user's calendar
class Event {
    var time: String
    var title: String
    var location: String
    
    
    init (time: String, title: String, location: String) {
        self.time = time
        self.title = title
        self.location = location
    }
}

