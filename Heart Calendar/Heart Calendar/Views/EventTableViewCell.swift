//
//  EventTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class EventTableViewCell: IndicatorTableViewCell {

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

        let rightMarginConstraint = NSLayoutConstraint(item: averageBPMLabel,
                                                       attribute: .right,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .rightMargin,
                                                       multiplier: 1.0,
                                                       constant: 0.0)

        let constraints = [
            eventTitleLabel.leftAnchor.constraint(equalTo: indicatorView.rightAnchor, constant: 15.0),
            eventTitleLabel.rightAnchor.constraint(equalTo: averageBPMLabel.leftAnchor, constant: -10),

            eventTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 25),
            eventTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),

            eventDateLabel.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 5),
            eventDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            eventDateLabel.leftAnchor.constraint(equalTo: eventTitleLabel.leftAnchor),
            eventDateLabel.rightAnchor.constraint(equalTo: averageBPMLabel.leftAnchor,
                                                  constant: -10),

            averageBPMLabel.topAnchor.constraint(equalTo: topAnchor),
            averageBPMLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            averageBPMLabel.widthAnchor.constraint(equalToConstant: 65),
            rightMarginConstraint
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
