//
//  EventTableViewCell.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class EventTableViewCell: CalendarTableViewCell {

    // MARK: - Properties

    let eventTitleLabel = UILabel()
    let eventDateLabel = UILabel()
    let averageBPMLabel = UILabel()

    static let reuseIdentifier = "reuseIdentifier"

    // MARK: - Initalization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        eventTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        eventTitleLabel.numberOfLines = 0

        eventDateLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        eventDateLabel.adjustsFontSizeToFitWidth = true

        averageBPMLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        averageBPMLabel.textAlignment = .right

        [eventTitleLabel, eventDateLabel, averageBPMLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        let constraints = [
            eventTitleLabel.leftAnchor.constraint(equalTo: calendarIndicatorView.rightAnchor,
                                                  constant: EventTableViewCell.indentConstant),
            eventTitleLabel.rightAnchor.constraint(equalTo: averageBPMLabel.leftAnchor,
                                                   constant: -10),

            eventTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            eventTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),

            eventDateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 5),
            eventDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            eventDateLabel.leftAnchor.constraint(equalTo: eventTitleLabel.leftAnchor),
            eventDateLabel.rightAnchor.constraint(equalTo: averageBPMLabel.leftAnchor,
                                                  constant: -10),

            averageBPMLabel.topAnchor.constraint(equalTo: self.topAnchor),
            averageBPMLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            averageBPMLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                   constant: -EventTableViewCell.indentConstant),
            averageBPMLabel.widthAnchor.constraint(equalToConstant: 65)

        ]

        NSLayoutConstraint.activate(constraints)
    }
}
