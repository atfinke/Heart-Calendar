//
//  ViewController.swift
//  Heart Data Mock
//
//  Created by Andrew Finke on 3/26/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import EventKit
import HealthKit

class ViewController: UIViewController {

    // MARK: - Types

    struct Event {
        let title: String
        let startDate: Date
        let duration: TimeInterval
        let heartRate: Double
    }

    // MARK: - Properties

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter
    }()

    private let eventStore = EKEventStore()
    private let healthStore = HKHealthStore()

    // MARK: - Actions

    @IBAction func pressedStart(_ sender: Any) {
        for calendar in eventStore.calendars(for: .event) {
            do {
                try eventStore.removeCalendar(calendar, commit: true)
            } catch {
                print(error)
            }
        }

        let calendars = [
            "Workout": UIColor.green,
            "Life": view.tintColor!,
            "NU Classes": UIColor.purple
        ]

        let workoutEvents = [
            Event(title: "Track",
                  startDate: formatter.date(from: "03-21-2018 07:00")!,
                  duration: 2 * 60 * 60,
                  heartRate: 156),
            Event(title: "Tennis",
                  startDate: formatter.date(from: "03-26-2018 15:00")!,
                  duration: 1.5 * 60 * 60,
                  heartRate: 135)
        ]

        let lifeEvents = [
            Event(title: "Apple Event",
                  startDate: formatter.date(from: "03-27-2018 10:00")!,
                  duration: 2.5 * 60 * 60,
                  heartRate: 92),
            Event(title: "Game Night",
                  startDate: formatter.date(from: "03-22-2018 22:00")!,
                  duration: 1.5 * 60 * 60,
                  heartRate: 72),
            Event(title: "Submit App",
                  startDate: formatter.date(from: "03-20-2018 12:30")!,
                  duration: 0.5 * 60 * 60,
                  heartRate: 66),
            Event(title: "Draft Paper",
                  startDate: formatter.date(from: "03-19-2018 12:30")!,
                  duration: 0.5 * 60 * 60,
                  heartRate: 54)
        ]

        let classEvents = [
            Event(title: "EECS 315: Discussion",
                  startDate: formatter.date(from: "03-23-2018 14:00")!,
                  duration: 3 * 60 * 60,
                  heartRate: 60),
            Event(title: "EECS 315: Discussion",
                  startDate: formatter.date(from: "03-16-2018 14:00")!,
                  duration: 3 * 60 * 60,
                  heartRate: 55),
            Event(title: "EECS 315: SIG",
                  startDate: formatter.date(from: "03-20-2018 16:00")!,
                  duration: 1 * 60 * 60,
                  heartRate: 85)
        ]

        let calendarEvents: [String: [Event]] = [
            "Workout": workoutEvents,
            "Life": lifeEvents,
            "NU Classes": classEvents
        ]

        for (title, color) in calendars {
            let calendar = createCalendar(title: title, color: color)
            for event in calendarEvents[title] ?? [] {
                createEvent(from: event, calendar: calendar)
            }
        }
    }

    @IBAction func pressedEventAccess(_ sender: Any) {
        eventStore.requestAccess(to: .event) { (_, error) in
            print(error)
        }
    }
    
    @IBAction func pressedHealthAccess(_ sender: Any) {
        let write = HKSampleType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: Set([write]), read: nil) { (_, error) in
            print(error)
        }
    }

    // MARK: - Events

    private func createCalendar(title: String, color: UIColor) -> EKCalendar {
        let calendar = EKCalendar(for: .event, eventStore: eventStore)

        let source = eventStore.sources.first(where: { $0.sourceType == .local })
        calendar.source = source
        calendar.title = title
        calendar.cgColor = color.cgColor

        do {
            try eventStore.saveCalendar(calendar, commit: true)
        } catch {
            fatalError(error.localizedDescription)
        }

        return calendar
    }

    private func createEvent(from event: Event,
                             calendar: EKCalendar) {

        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.title
        ekEvent.startDate = event.startDate
        ekEvent.endDate = event.startDate.addingTimeInterval(event.duration)
        ekEvent.calendar = calendar

        do {
            try eventStore.save(ekEvent, span: .thisEvent, commit: true)
        } catch {
            fatalError(error.localizedDescription)
        }

        addHeartRate(heartRate: event.heartRate, event: ekEvent)
    }

    // MARK: - Health

    private func addHeartRate(heartRate: Double, event: EKEvent) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            fatalError()
        }

        let quantity = HKQuantity(unit: HKUnit.count().unitDivided(by: HKUnit.minute()), doubleValue: heartRate)

        let date = event.startDate.addingTimeInterval(1)
        let sample = HKQuantitySample(type: heartRateType,
                                                   quantity: quantity,
                                                   start: date,
                                                   end: date)

        healthStore.save(sample) { (_, _) in }
    }

}
