//
//  EventTableViewController.swift
//  Heart Cal
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

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let name = NSNotification.Name.UIApplicationDidBecomeActive
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
                if eventSuccess {
                    self.model.authorizeHealth { healthSuccess, _ in
                        if healthSuccess {
                            self.reload(completion: nil)
                        } else {
                            self.presentAlert(title: AlertConstants.healthTitle,
                                              message: AlertConstants.healthMessage)
                        }
                    }
                } else {
                    self.presentAlert(title: AlertConstants.calendarTitle,
                                      message: AlertConstants.calendarMessage)
                }
            }
        } else {
            let controller = SetupViewController()
            controller.model = model
            controller.completed = { [weak self] in
                PreferencesManager.shared.completedSetup = true
                self?.dismiss(animated: true, completion: nil)
                self?.reload(completion: nil)
            }
            let navController = UINavigationController(rootViewController: controller)
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
        isUpdatingModel = true
        let startDate = Date()
        DispatchQueue.global(qos: .userInitiated).async {
            self.model.update {
                DispatchQueue.main.async {
                    func complete() {
                        self.isUpdatingModel = false
                        self.tableView.reloadData()
                        self.tableView.refreshControl?.endRefreshing()
                        completion?()
                    }

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
            (model.noDataEvents.isEmpty || PreferencesManager.shared.shouldHideEmptyEvents)
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

        preferencesController = controller
        preferencesController?.calendars = model.calendars()

        func scheduleReview() {
            reviewTimer?.invalidate()
            reviewTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in
                DispatchQueue.main.async {
                    if self.preferencesController == nil {
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
                self?.reload(completion: {
                    self?.dismiss(animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    })
                    scheduleReview()
                })
            }

        }
    }

}
