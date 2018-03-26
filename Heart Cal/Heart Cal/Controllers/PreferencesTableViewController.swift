//
//  PreferencesTableViewController.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import Crashlytics

class PreferencesTableViewController: UITableViewController {

    // MARK: - Properties

    var preferencesUpdated = false
    var donePressed: ((Bool) -> Void)?

    var calendars = [EventManager.Calendar]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }

    private let loadingBarButtonItem: UIBarButtonItem = {
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.sizeToFit()
        activityView.startAnimating()
        return UIBarButtonItem(customView: activityView)
    }()

    // MARK: - Actions

    @IBAction func doneButtonPressed(_ sender: Any) {
        if preferencesUpdated {
            navigationItem.rightBarButtonItem = loadingBarButtonItem
        }
        donePressed?(preferencesUpdated)
    }

    @objc
    func switchToggled(sender: UISwitch) {
        PreferencesManager.shared.shouldHideEmptyEvents = sender.isOn
        preferencesUpdated = true
        UISelectionFeedbackGenerator().selectionChanged()

        Answers.logCustomEvent(withName: "Preferences-HideEmptyEvents",
                               customAttributes: ["HideEmptyEvents": PreferencesManager.shared.shouldHideEmptyEvents])
    }

}
