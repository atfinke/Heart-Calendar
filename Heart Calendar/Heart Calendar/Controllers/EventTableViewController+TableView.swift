//
//  EventTableViewController+TableView.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

extension EventTableViewController {

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        if shouldShowInfoCell() {
            return 1
        } else {
            return PreferencesManager.shared.shouldHideEmptyEvents ? 1 : 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowInfoCell() {
            return 1
        } else if section == 0 {
            return model.validEvents.count
        } else if section == 1 {
            return model.noDataEvents.count
        } else {
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return "Events With No Heart Rate Data"
        } else {
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldShowInfoCell() {
            //swiftlint:disable:next line_length
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoReuseIdentifier", for: indexPath)
            cell.textLabel?.text = isUpdatingModel ? "Loading Events..." : "No Events Found"
            return cell
        }

        //swiftlint:disable:next line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.reuseIdentifier, for: indexPath) as? EventTableViewCell else {
            fatalError()
        }

        let event: Model.HeartRateEvent
        if indexPath.section == 0 {
            event = model.validEvents[indexPath.row]
        } else if indexPath.section == 1 {
            event = model.noDataEvents[indexPath.row]
        } else {
            fatalError()
        }

        cell.indicatorView.backgroundColor = event.event.calendarColor
        cell.eventTitleLabel.text = event.event.title
        cell.eventDateLabel.text = formatter.string(from: event.event.startDate, to: event.event.endDate)

        if let measure = event.measure?.average {
            cell.averageBPMLabel.text = Int(measure).description
        } else if indexPath.section == 1 {
            cell.averageBPMLabel.text = "-"
        }

        return cell
    }

}
