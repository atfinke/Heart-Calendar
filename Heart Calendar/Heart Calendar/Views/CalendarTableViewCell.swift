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

    let calendarIndicatorView = UIView()
    static let indentConstant: CGFloat = 18.0

    // MARK: - Initalization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        calendarIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(calendarIndicatorView)

        let constraints = [
            calendarIndicatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            calendarIndicatorView.widthAnchor.constraint(equalToConstant: 18.0),
            calendarIndicatorView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Overrides

    func overrideIndicatorWidth(width: CGFloat) {
        NSLayoutConstraint.deactivate(calendarIndicatorView.constraints)
        let constraints = [
            calendarIndicatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            calendarIndicatorView.widthAnchor.constraint(equalToConstant: width),
            calendarIndicatorView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = calendarIndicatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        calendarIndicatorView.backgroundColor = color
    }

}
