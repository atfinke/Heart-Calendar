//
//  EventManager.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import EventKit

class EventManager {

    // MARK: - Types

    struct Event: Comparable {

        private let event: EKEvent

        var title: String {
            return event.title
        }
        var startDate: Date {
            return event.startDate
        }
        var endDate: Date {
            return event.endDate
        }
        var calendarColor: UIColor {
            return UIColor(cgColor: event.calendar.cgColor)
        }
        var calendarName: String {
            return event.calendar.title
        }

        init(_ event: EKEvent) {
            self.event = event
        }

        //swiftlint:disable:next operator_whitespace
        static func <(lhs: EventManager.Event, rhs: EventManager.Event) -> Bool {
            // 1. Check event title (e.g. 1. A_Event, 2. B_Event)
            // 2. Check event start date (e.g. 1. A_Event (starts 1/1), 2. A_Event (starts 1/2))
            // 3. Check event calendar title (e.g. 1. A_Event (A_Cal), 2. A_Event (B_Cal))
            // 4. Check event calendar identifier
            if lhs.event.title == rhs.event.title {
                if lhs.event.startDate == rhs.event.startDate {
                    if lhs.event.calendar.title == rhs.event.calendar.title {
                        return lhs.event.calendar.calendarIdentifier > rhs.event.calendar.calendarIdentifier
                    } else {
                        return lhs.event.calendar.title > rhs.event.calendar.title
                    }
                } else {
                    return lhs.event.startDate > rhs.event.startDate
                }
            } else {
                return lhs.event.title > rhs.event.title
            }
        }

        //swiftlint:disable:next operator_whitespace
        static func ==(lhs: EventManager.Event, rhs: EventManager.Event) -> Bool {
            return lhs.event == rhs.event
        }
    }

    struct Calendar {

        fileprivate let calendar: EKCalendar

        var title: String {
            return calendar.title
        }
        var identifier: String {
            return calendar.calendarIdentifier
        }
        var color: UIColor {
            return UIColor(cgColor: calendar.cgColor)
        }

        init(_ calendar: EKCalendar) {
            self.calendar = calendar
        }
    }

    // MARK: - Properties

    private let eventStore = EKEventStore()

    // MARK: - Methods

    func authorize(completion: @escaping (Bool, Error?) -> Void) {
        eventStore.requestAccess(to: .event) { (success, error) in
            completion(success, error)
        }
    }

    func allStoreCalendars() -> [Calendar] {
        return eventStore.calendars(for: .event).map { Calendar($0) }
    }

    func events(between startDate: Date, and endDate: Date) -> [Event] {
        let storeCalendars = allStoreCalendars()

        var calendarIdentifiers = PreferencesManager.shared.calendarIdentifiers
        if calendarIdentifiers == nil {
            calendarIdentifiers = storeCalendars.map { $0.calendar.calendarIdentifier }
            PreferencesManager.shared.calendarIdentifiers = calendarIdentifiers
        }

        guard let calendarIDs = calendarIdentifiers, !calendarIDs.isEmpty else { return [] }
        let selectedCalendars = storeCalendars
            .map { $0.calendar }
            .filter { calendarIDs.contains($0.calendarIdentifier) }

        let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                      end: endDate,
                                                      calendars: selectedCalendars)

        return eventStore.events(matching: predicate).map { Event($0) }
    }
}
