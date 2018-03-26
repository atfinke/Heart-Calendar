//
//  CalendarTableViewCell.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    // MARK: - Properties

    let calendarView = UIView()
    static let indentConstant: CGFloat = 18.0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let calendarViewCircleSize: CGFloat = 15.0
        calendarView.layer.cornerRadius = calendarViewCircleSize / 2.0

        calendarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarView)

        let constraints = [
            calendarView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                               constant: CalendarTableViewCell.indentConstant),
            calendarView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            calendarView.widthAnchor.constraint(equalToConstant: calendarViewCircleSize),
            calendarView.heightAnchor.constraint(equalToConstant: calendarViewCircleSize)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = calendarView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        calendarView.backgroundColor = color
    }

}
