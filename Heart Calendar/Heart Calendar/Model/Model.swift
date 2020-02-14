//
//  Model.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import Foundation
import Crashlytics

class Model {

    // MARK: - Types

    struct HeartRateEvent: Equatable {
        let event: EventManager.Event
        let measure: HealthManager.HeartRateMeasure?

        //swiftlint:disable:next operator_whitespace
        static func ==(lhs: HeartRateEvent, rhs: HeartRateEvent) -> Bool {
            return lhs.event == rhs.event && lhs.measure == rhs.measure
        }
    }

    // MARK: - Properties

    private(set) var validEvents = [HeartRateEvent]()
    private(set) var noDataEvents = [HeartRateEvent]()

    private let eventManager = EventManager()
    private let healthManager = HealthManager()

    // MARK: - User Privacy

    func authorizeEvents(completion: @escaping (Bool, Error?) -> Void) {
        eventManager.authorize(completion: completion)
    }

    func authorizeHealth(completion: @escaping (Bool, Error?) -> Void) {
        healthManager.authorize(completion: completion)
    }

    // MARK: - Methods

    func calendars() -> [EventManager.Calendar] {
        return eventManager.allStoreCalendars()
            .sorted { $0.title.lowercased() < $1.title.lowercased() }
    }

    func update(completion: @escaping ((_ newResults: Bool) -> Void)) {
        guard !Thread.isMainThread else { fatalError("Called on main thread") }
        Answers.logCustomEvent(withName: "Model-Update", customAttributes: nil)

        var newValidEvents = [HeartRateEvent]()
        var newNoDataEvents = [HeartRateEvent]()

        let days = PreferencesManager.shared.timespan.days
        let endDate = Date()
        let startDate = endDate - (TimeInterval(days) * 24 /* Hours */ * 60 /* Min */ * 60 /* Sec */)

        let calendarEvents = eventManager.events(between: startDate, and: endDate)
        guard !calendarEvents.isEmpty else {
            self.validEvents = []
            self.noDataEvents = []
            completion(true)
            return
        }

        for event in calendarEvents {
            healthManager.measure(between: event.startDate, and: event.endDate, completion: { measure in
                let heartEvent = HeartRateEvent(event: event, measure: measure)
                if let unwrapped = measure, unwrapped.average != 0 {
                    newValidEvents.append(heartEvent)
                } else {
                    newNoDataEvents.append(heartEvent)
                }

                if newNoDataEvents.count + newValidEvents.count == calendarEvents.count {
                    let sorted = self.sort(validEvents: newValidEvents, noDataEvents: newNoDataEvents)

                    let newResults = self.validEvents != sorted.validEvents ||
                        self.noDataEvents != sorted.noDataEvents

                    self.validEvents = sorted.validEvents
                    self.noDataEvents = sorted.noDataEvents
                    completion(newResults)
                }
            })
        }
    }

    //swiftlint:disable line_length
    private func sort(validEvents: [HeartRateEvent],
                      noDataEvents: [HeartRateEvent]) -> (validEvents: [HeartRateEvent], noDataEvents: [HeartRateEvent]) {

        let sortFunction: (Model.HeartRateEvent, Model.HeartRateEvent) -> Bool
        switch PreferencesManager.shared.sortStyle {

        case .highest:
            sortFunction = { (lhs, rhs) in
                let lhsAverage = lhs.measure?.average ?? 0
                let rhsAverage = rhs.measure?.average ?? 0
                if lhsAverage == rhsAverage {
                    return lhs.event > rhs.event
                } else {
                    return lhsAverage > rhsAverage
                }
            }
        case .lowest:
            sortFunction = { (lhs, rhs) in
                let lhsAverage = lhs.measure?.average ?? 0
                let rhsAverage = rhs.measure?.average ?? 0
                if lhsAverage == rhsAverage {
                    return lhs.event > rhs.event
                } else {
                    return lhsAverage < rhsAverage
                }
            }
        case .newest:
            sortFunction = { (lhs, rhs) in
                return lhs.event.startDate > rhs.event.startDate
            }
        case .oldest:
            sortFunction = { (lhs, rhs) in
                return lhs.event.startDate < rhs.event.startDate
            }
        }

        return (validEvents: validEvents.sorted(by: sortFunction),
                noDataEvents: noDataEvents.sorted { $0.event > $1.event })
    }

}
