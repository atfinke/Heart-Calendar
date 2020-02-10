//
//  PreferencesTableViewController+TableView.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import Crashlytics

extension PreferencesTableViewController {

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return calendars.count
        } else if section == 1 {
            return PreferencesManager.SortStyle.all.count
        } else if section == 2 {
            return PreferencesManager.Timespan.all.count
        } else if section == 3 {
            return 1
        } else {
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Calendars"
        } else if section == 1 {
            return "Event Sorting"
        } else if section == 2 {
            return "Timespan"
        } else if section == 3 {
            return "Other"
        } else {
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            //swiftlint:disable:next line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else {
                fatalError()
            }
            let calendar = calendars[indexPath.row]
            cell.calendarTitleLabel.text = calendar.title
            cell.indicatorView.backgroundColor = calendar.color

            let calendarIdentifiers = PreferencesManager.shared.calendarIdentifiers ?? []
            cell.accessoryType = calendarIdentifiers.contains(calendar.identifier) ? .checkmark : .none

            cell.accessibilityHint = "Toggles if events should be included from this calendar."

            return cell
        } else if indexPath.section == 3 {
            //swiftlint:disable:next line_length
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseIdentifier, for: indexPath) as? SwitchTableViewCell else {
                fatalError()
            }
            cell.infoLabel.text = "Hide events with no BPM data"
            cell.preferenceSwitch.isOn = PreferencesManager.shared.shouldHideNoDataEvents
            cell.preferenceSwitch.addTarget(self, action: #selector(switchToggled(sender:)), for: .valueChanged)

            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if indexPath.section == 1 {
            let item = PreferencesManager.SortStyle.all[indexPath.row]
            cell.textLabel?.text = item.description
            cell.accessoryType = PreferencesManager.shared.sortStyle == item ? .checkmark : .none

            cell.accessibilityHint = "Sets how calendar events should be sorted."
        } else if indexPath.section == 2 {
            let item = PreferencesManager.Timespan.all[indexPath.row]
            cell.textLabel?.text = item.description
            cell.accessoryType = PreferencesManager.shared.timespan == item ? .checkmark : .none

            cell.accessibilityHint = "Sets how far back Heart Calendar should look for calendar events."
        } else {
            fatalError()
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        preferencesUpdated = true
        UISelectionFeedbackGenerator().selectionChanged()

        if indexPath.section == 0 {
            let calendar = calendars[indexPath.row]
            var calendarIdentifiers = PreferencesManager.shared.calendarIdentifiers ?? []
            if let index = calendarIdentifiers.firstIndex(of: calendar.identifier) {
                calendarIdentifiers.remove(at: index)
                PreferencesManager.shared.calendarIdentifiers = calendarIdentifiers
            } else {
                calendarIdentifiers.append(calendar.identifier)
                PreferencesManager.shared.calendarIdentifiers = calendarIdentifiers
            }
            tableView.reloadRows(at: [indexPath], with: .none)
        } else if indexPath.section == 1 {
            PreferencesManager.shared.sortStyle = PreferencesManager.SortStyle.all[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            Answers.logCustomEvent(withName: "Preferences-SortStyle",
                                   customAttributes: ["SortStyle": PreferencesManager.shared.sortStyle.rawValue])
        } else if indexPath.section == 2 {
            PreferencesManager.shared.timespan = PreferencesManager.Timespan.all[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
            Answers.logCustomEvent(withName: "Preferences-Timespan",
                                   customAttributes: ["Timespan": PreferencesManager.shared.timespan.rawValue])
        } else if indexPath.section == 3 {
            // switch cell
        } else {
            fatalError()
        }
    }

}
