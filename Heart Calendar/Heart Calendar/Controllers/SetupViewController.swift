//
//  SetupViewController.swift
//  Health Cal
//
//  Created by Andrew Finke on 12/10/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    // MARK: - Properties

    var model: Model?
    var completed: (() -> Void)?

    private var isCalendarAuthenticated = false
    private var isHealthAuthenticated = false

    private let calendarView: AccessView = {
        let accessView = AccessView(frame: .zero)
        accessView.translatesAutoresizingMaskIntoConstraints = false

        let text = "Heart Calendar needs access to your calendar to read event titles and dates."
        accessView.descriptionLabel.text = text
        accessView.titleLabel.text = "Calendar Access"
        return accessView
    }()

    private let healthView: AccessView = {
        let accessView = AccessView(frame: .zero)
        accessView.translatesAutoresizingMaskIntoConstraints = false

        let text = "Heart Calendar needs access to your heart rate infomation."
        accessView.descriptionLabel.text = text
        accessView.titleLabel.text = "Health Access"
        return accessView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Welcome!"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(calendarView)
        view.addSubview(healthView)

        let constraints = [
            calendarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            calendarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),

            healthView.leftAnchor.constraint(equalTo: view.leftAnchor),
            healthView.rightAnchor.constraint(equalTo: view.rightAnchor),
            healthView.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 30)
        ]
        NSLayoutConstraint.activate(constraints)

        calendarView.pressed = { [weak self] in
            self?.model?.authorizeEvents(completion: { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        self?.calendarView.disableButton(title: "Calendar Access Granted")
                        self?.isCalendarAuthenticated = true
                        self?.checkAuthentication()
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        self?.presentAlert(title: AlertConstants.calendarTitle,
                                          message: AlertConstants.calendarMessage)
                    }
                }
            })
        }

        healthView.pressed = { [weak self] in
            self?.model?.authorizeHealth(completion: { (success, _) in
                DispatchQueue.main.async {
                    if success {
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        self?.healthView.disableButton(title: "Health Access Granted")
                        self?.isHealthAuthenticated = true
                        self?.checkAuthentication()
                    } else {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        self?.presentAlert(title: AlertConstants.healthTitle,
                                          message: AlertConstants.healthMessage)
                    }
                }
            })
        }

    }

    // MARK: - Helpers

    func checkAuthentication() {
        guard isCalendarAuthenticated && isHealthAuthenticated else { return }
        completed?()
    }

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

}
