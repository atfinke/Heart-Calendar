//
//  EventTableViewController.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit
import StoreKit
import Crashlytics

class EventTableViewController: UITableViewController {

    // MARK: - Properties

    let model = Model()
    var isUpdatingModel = true

    let formatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private var reviewTimer: Timer?
    private var preferencesController: PreferencesTableViewController?
    private var isHidingNoDataEvents = PreferencesManager.shared.shouldHideNoDataEvents

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = UIApplication.didBecomeActiveNotification
        //swiftlint:disable:next discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                if let controller = self.preferencesController {
                    controller.calendars = self.model.calendars()
                } else if PreferencesManager.shared.completedSetup {
                    self.reload(completion: nil)
                }
            }
        }

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(controlReload), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PreferencesManager.shared.completedSetup {
            model.authorizeEvents { eventSuccess, _ in
                self.model.authorizeHealth { healthSuccess, _ in
                    if !eventSuccess {
                        self.presentAlert(title: AlertConstants.calendarTitle,
                                          message: AlertConstants.calendarMessage)
                    } else if !healthSuccess {
                        self.presentAlert(title: AlertConstants.healthTitle,
                                          message: AlertConstants.healthMessage)
                    }
                }
            }

        } else {
            let controller = SetupTableViewController()
            controller.model = model
            controller.setupCompleted = { [weak self] in
                PreferencesManager.shared.completedSetup = true
                self?.dismiss(animated: true, completion: nil)
                self?.reload(completion: nil)
            }
            let navController = UINavigationController(rootViewController: controller)
            navController.isModalInPresentation = true
            navController.modalPresentationStyle = .fullScreen
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.present(navController, animated: false, completion: nil)
        }
    }

    // MARK: - Reloading

    @objc
    func controlReload() {
        reload(completion: nil)
        Answers.logCustomEvent(withName: "Reload-RefreshControl", customAttributes: nil)
    }

    func reload(completion: (() -> Void)?) {
        let startDate = Date()
        isUpdatingModel = true

        DispatchQueue.global(qos: .userInitiated).async {
            self.model.update { needsUpdate in
                DispatchQueue.main.async {
                    func complete() {
                        self.isUpdatingModel = false
                        self.tableView.refreshControl?.endRefreshing()

                        // Update the table if the user has updated the hiding no data events preference
                        let shouldHideNoDataEvents = PreferencesManager.shared.shouldHideNoDataEvents
                        let updatedHidingPreferences = shouldHideNoDataEvents != self.isHidingNoDataEvents
                        self.isHidingNoDataEvents = shouldHideNoDataEvents

                        guard needsUpdate || updatedHidingPreferences else {
                            completion?()
                            return
                        }

                        self.tableView.reloadData()
                        if !self.model.validEvents.isEmpty {
                            let lastIndex = PreferencesManager.shared.shouldHideNoDataEvents ? 0 : 1
                            self.tableView.reloadSections(IndexSet(integersIn: 0...lastIndex), with: .fade)
                        }
                        completion?()
                    }

                    // Ensures that the refresh control doesn't get into a bad state
                    if -startDate.timeIntervalSinceNow < 0.5 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            complete()
                        })
                    } else {
                        complete()
                    }
                }
            }
        }

        Answers.logCustomEvent(withName: "Reload-Method", customAttributes: nil)
    }

    // MARK: - Other

    func shouldShowInfoCell() -> Bool {
        return model.validEvents.isEmpty &&
            (model.noDataEvents.isEmpty || PreferencesManager.shared.shouldHideNoDataEvents)
    }

    func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
            let controller = navController.viewControllers.first as? PreferencesTableViewController else {
                fatalError()
        }
        navController.isModalInPresentation = true
        
        preferencesController = controller
        preferencesController?.calendars = model.calendars()

        func scheduleReview() {
            reviewTimer?.invalidate()
            reviewTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
                DispatchQueue.main.async {
                    if self.preferencesController == nil &&
                        -PreferencesManager.shared.lastReviewPromptDate.timeIntervalSinceNow > 60 * 2 {
                        PreferencesManager.shared.lastReviewPromptDate = Date()
                        SKStoreReviewController.requestReview()
                    }
                }
            })
        }

        preferencesController?.donePressed = { [weak self] updatedPreferences in
            self?.preferencesController = nil
            guard updatedPreferences else {
                self?.dismiss(animated: true, completion: nil)
                scheduleReview()
                return
            }

            DispatchQueue.main.async {
                self?.reload {
                    self?.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        if let indexPath = self?.tableView.indexPathForRow(at: .zero) {
                            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    })
                    scheduleReview()
                }
            }

        }
    }

}
