//
//  CalendarTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class CalendarTableViewCell: IndicatorTableViewCell {

    // MARK: - Properties

    let calendarTitleLabel = UILabel()
    static let reuseIdentifier = "calendarReuseIdentifier"

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        overrideIndicatorWidth(width: 7)

        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        calendarTitleLabel.font = UIFontMetrics(forTextStyle: UIFont.TextStyle.body).scaledFont(for: font)

        calendarTitleLabel.numberOfLines = 0
        calendarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarTitleLabel)

        let leftMarginConstraint = NSLayoutConstraint(item: calendarTitleLabel,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .leftMargin,
                                                      multiplier: 1.0,
                                                      constant: 0.0)

        let constraints = [
            leftMarginConstraint,
            // 50 for the checkmark
            calendarTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50),
            calendarTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            calendarTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
