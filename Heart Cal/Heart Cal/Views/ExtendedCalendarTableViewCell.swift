//
//  ExtendedCalendarTableViewCell.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class ExtendedCalendarTableViewCell: CalendarTableViewCell {

    // MARK: - Properties

    let calendarTitleLabel = UILabel()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        calendarTitleLabel.numberOfLines = 0
        calendarTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        calendarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarTitleLabel)

        let constraints = [
            calendarTitleLabel.leftAnchor.constraint(equalTo: calendarView.rightAnchor,
                                                     constant: EventTableViewCell.indentConstant),
            calendarTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                      constant: -50),

            calendarTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            calendarTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
