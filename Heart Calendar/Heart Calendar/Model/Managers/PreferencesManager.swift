//
//  PreferencesManager.swift
//  Heart Cal
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

    // MARK: - Properties

    static let shared = PreferencesManager()
    private let defaults = UserDefaults.standard

    // MARK: - Preferences

    var sortStyle: SortStyle {
        get {
            let rawValue = defaults.integer(forKey: SortStyle.defaultsKey)
            guard let style = SortStyle(rawValue: rawValue) else {
                fatalError()
            }
            return style
        }
        set {
            defaults.set(newValue.rawValue, forKey: SortStyle.defaultsKey)
        }
    }

    var timespan: Timespan {
        get {
            if defaults.value(forKey: Timespan.defaultsKey) == nil {
                // set default timespan to one week
                defaults.set(Timespan.week.rawValue, forKey: Timespan.defaultsKey)
            }

            let rawValue = defaults.integer(forKey: Timespan.defaultsKey)
            guard let timespan = Timespan(rawValue: rawValue) else {
                fatalError()
            }
            return timespan
        }
        set {
            defaults.set(newValue.rawValue, forKey: Timespan.defaultsKey)
        }
    }

    var calendarIdentifiers: [String]? {
        get {
            return defaults.array(forKey: "CalendarIDS") as? [String]
        }
        set {
            return defaults.set(newValue, forKey: "CalendarIDS")
        }
    }

    var shouldHideEmptyEvents: Bool {
        get {
            return defaults.bool(forKey: "shouldHideNoDataEvents")
        }
        set {
            return defaults.set(newValue, forKey: "shouldHideNoDataEvents")
        }
    }

    var completedSetup: Bool {
        get {
            return defaults.bool(forKey: "completedSetup")
        }
        set {
            return defaults.set(newValue, forKey: "completedSetup")
        }
    }

}
