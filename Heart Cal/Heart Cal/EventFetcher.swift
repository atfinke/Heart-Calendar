//
//  CalStuff.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import EventKit

struct Event {
    let title: String
    let start: Date
    let end: Date
}

class EventFetcher: NSObject {

    let eventStore = EKEventStore()

    func authorize(completion: @escaping (Bool) -> ()) {
        eventStore.requestAccess(to: .event) { (success, error) in
            completion(success)
        }
    }

    func fetch(start: Date, end: Date) -> [Event] {
        assert(!Thread.isMainThread)

        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let storeEvents = eventStore.events(matching: predicate)

        return storeEvents.map { event in
            return Event(title: event.title, start: event.startDate, end: event.endDate)
        }
    }
}


