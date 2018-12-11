//
//  SetupTableViewController.swift
//  Health Calendar
//
//  Created by Andrew Finke on 12/10/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

// To support Dynamic Type causing labels to go off screen, this controller is now a table view
class SetupTableViewController: UITableViewController {

    // MARK: - Types

    enum AuthorizationType {
        case calendar, health

        static let all: [AuthorizationType] = [.calendar, .health]

        var title: String {
            switch self {
            case .calendar: return "Calendar Access"
            case .health: return "Health Access"
            }
        }

        var description: String {
            switch self {
            case .calendar: return "Heart Calendar needs access to your calendar to read event titles and dates."
            case .health: return "Heart Calendar needs access to your heart rate infomation."
            }
        }

        var enabledText: String {
            switch self {
            case .calendar: return "Calendar Access Granted"
            case .health: return "Health Access Granted"
            }
        }

        var alertInfo: (title: String, message: String) {
            switch self {
            case .calendar: return (title: AlertConstants.calendarTitle, message: AlertConstants.calendarMessage)
            case .health: return (title: AlertConstants.healthTitle, message: AlertConstants.healthMessage)
            }
        }
    }

    // MARK: - Properties

    var model: Model?
    var setupCompleted: (() -> Void)?

    private var isCalendarAuthenticated = false
    private var isHealthAuthenticated = false

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(AccessTableViewCell.self,
                           forCellReuseIdentifier: AccessTableViewCell.reuseIdentifier)

        title = "Welcome!"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.isScrollEnabled = tableView.contentSize.height >= tableView.frame.height
    }

    // MARK: - Access Buttons

    @objc
    func calendarButtonPressed(_ button: UIButton) {
        authorize(type: .calendar, button: button)
    }

    @objc
    func healthButtonPressed(_ button: UIButton) {
        authorize(type: .health, button: button)
    }

    func authorize(type: AuthorizationType, button: UIButton) {
        guard let model = model, Thread.isMainThread else {
            fatalError("Model not set")
        }

        // Called when the privacy request has completed
        func completion(success: Bool, error: Error?) {
            DispatchQueue.main.async {
                let generator = UINotificationFeedbackGenerator()
                if success {
                    generator.notificationOccurred(.success)

                    button.isEnabled = false
                    button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)

                    switch type {
                    case .calendar: self.isCalendarAuthenticated = true
                    case .health: self.isHealthAuthenticated = true
                    }

                    if self.isCalendarAuthenticated && self.isHealthAuthenticated {
                        self.setupCompleted?()
                    }
                } else {
                    generator.notificationOccurred(.error)
                    self.presentErrorAlert(type: type)
                }
            }
        }

        switch type {
        case .calendar: model.authorizeEvents(completion: completion(success:error:))
        case .health: model.authorizeHealth(completion: completion(success:error:))
        }
    }

    func presentErrorAlert(type: AuthorizationType) {
        let alertInfo = type.alertInfo

        let alertController = UIAlertController(title: alertInfo.title,
                                                message: alertInfo.message,
                                                preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthorizationType.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccessTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? AccessTableViewCell else {
            fatalError()
        }

        let authorizationType = AuthorizationType.all[indexPath.row]
        cell.titleLabel.text = authorizationType.title
        cell.descriptionLabel.text = authorizationType.description
        cell.button.setTitle(authorizationType.enabledText, for: UIControl.State.disabled)

        switch authorizationType {
        case .calendar: cell.button.addTarget(self,
                                              action: #selector(calendarButtonPressed(_:)),
                                              for: UIControl.Event.touchUpInside)

        case .health: cell.button.addTarget(self,
                                            action: #selector(healthButtonPressed(_:)),
                                            for: UIControl.Event.touchUpInside)
        }

        return cell
    }
}
