//
//  PreferencesManager.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class PreferencesManager {

    // MARK: - Types

    enum Timespan: Int {
        case day, week, month, year

        static let defaultsKey = "Timespan"
        static let all: [Timespan] = [.day, .week, .month, .year]

        var description: String {
            switch self {
            case .day:      return "Last Day"
            case .week:     return "Last Week"
            case .month:    return "Last Month"
            case .year:     return "Last Year"
            }
        }

        var days: Int {
            switch self {
            case .day:      return 1
            case .week:     return 7
            case .month:    return 31
            case .year:     return 365
            }
        }
    }

    enum SortStyle: Int {
        case highest, lowest, newest, oldest

        static let defaultsKey = "SortStyle"
        static let all: [SortStyle] = [.highest, .lowest, .newest, .oldest]

        var description: String {
            switch self {
            case .highest:  return "Highest to lowest by BPM"
            case .lowest:   return "Lowest to highest by BPM"
            case .newest:   return "Most recent first"
            case .oldest:   return "Oldest first"
            }
        }
    }

    // MARK: - Preferences

    var completedSetup: Bool {
        didSet {
            defaults.set(completedSetup, forKey: "completedSetup")
        }
    }

    var lastPromptDate: Date {
        didSet {
            defaults.set(lastPromptDate, forKey: "lastPromptDate")
        }
    }

    var calendarIdentifiers: [String]? {
        didSet {
            defaults.set(calendarIdentifiers, forKey: "calendarIdentifiers")
        }
    }

    var sortStyle: SortStyle {
        didSet {
            defaults.set(sortStyle.rawValue, forKey: SortStyle.defaultsKey)
        }
    }

    var timespan: Timespan {
        didSet {
            defaults.set(timespan.rawValue, forKey: Timespan.defaultsKey)
        }
    }

    var shouldHideNoDataEvents: Bool {
        didSet {
            defaults.set(shouldHideNoDataEvents, forKey: "shouldHideNoDataEvents")
        }
    }

    // MARK: - Properties

    static let shared = PreferencesManager()
    private let defaults = UserDefaults.standard

    // MARK: - Initalization

    init() {
        self.completedSetup = defaults.bool(forKey: "completedSetup")
        self.lastPromptDate = defaults.object(forKey: "lastPromptDate") as? Date ?? Date()
        self.calendarIdentifiers = defaults.array(forKey: "calendarIdentifiers") as? [String]

        // Load Sort Style
        var rawValue = defaults.integer(forKey: SortStyle.defaultsKey)
        guard let style = SortStyle(rawValue: rawValue) else {
            fatalError()
        }
        self.sortStyle = style

        // Load Timespan
        if defaults.value(forKey: Timespan.defaultsKey) == nil {
            // set default timespan to one week
            defaults.set(Timespan.week.rawValue, forKey: Timespan.defaultsKey)
        }
        rawValue = defaults.integer(forKey: Timespan.defaultsKey)
        guard let timespan = Timespan(rawValue: rawValue) else {
            fatalError()
        }
        self.timespan = timespan

        self.shouldHideNoDataEvents = defaults.bool(forKey: "shouldHideNoDataEvents")
    }

}
