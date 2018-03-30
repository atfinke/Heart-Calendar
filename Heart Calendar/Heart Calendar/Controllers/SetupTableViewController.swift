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

    // MARK: - Properties

    var model: Model?
    var completed: (() -> Void)?

    private var isCalendarAuthenticated = false
    private var isHealthAuthenticated = false

    private var calendarCell: AccessTableViewCell?
    private var healthCell: AccessTableViewCell?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(AccessTableViewCell.self,
                           forCellReuseIdentifier: AccessTableViewCell.reuseIdentifier)

        title = "Welcome!"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.isScrollEnabled = tableView.contentSize.height >= tableView.frame.height
    }

    // MARK: - Access Buttons

    func calendarButtonPressed() {
        model?.authorizeEvents(completion: { (success, _) in
            DispatchQueue.main.async {
                if success {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.calendarCell?.disableButton()
                    self.isCalendarAuthenticated = true
                    self.checkAuthentication()
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    self.presentAlert(title: AlertConstants.calendarTitle,
                                       message: AlertConstants.calendarMessage)
                }
            }
        })
    }

    func healthButtonPressed() {
        model?.authorizeHealth(completion: { (success, _) in
            DispatchQueue.main.async {
                if success {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.healthCell?.disableButton()
                    self.isHealthAuthenticated = true
                    self.checkAuthentication()
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    self.presentAlert(title: AlertConstants.healthTitle,
                                       message: AlertConstants.healthMessage)
                }
            }
        })
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

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccessTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? AccessTableViewCell else {
            fatalError()
        }

        if indexPath.row == 0 {
            let text = "Heart Calendar needs access to your calendar to read event titles and dates."
            cell.descriptionLabel.text = text
            cell.titleLabel.text = "Calendar Access"
            cell.button.setTitle("Calendar Access Granted", for: .disabled)

            cell.buttonPressed = { [weak self] in
                self?.calendarButtonPressed()
            }
            calendarCell = cell
        } else if indexPath.row == 1 {
            let text = "Heart Calendar needs access to your heart rate infomation."
            cell.descriptionLabel.text = text
            cell.titleLabel.text = "Health Access"
            cell.button.setTitle("Health Access Granted", for: .disabled)

            cell.buttonPressed = { [weak self] in
                self?.healthButtonPressed()
            }
            healthCell = cell
        } else {
            fatalError()
        }

        return cell
    }
}
