//
//  CalendarTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class IndicatorTableViewCell: UITableViewCell {

    // MARK: - Properties

    let indicatorView = UIView()
    private var marginConstraint: NSLayoutConstraint!

    // MARK: - Initalization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)

        let marginConstraint = NSLayoutConstraint(item: indicatorView,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leftMargin,
                                              multiplier: 1.0,
                                              constant: 0.0)
        self.marginConstraint = marginConstraint

        let constraints = [
            marginConstraint,
            indicatorView.leftAnchor.constraint(equalTo: leftAnchor),
            indicatorView.topAnchor.constraint(equalTo: topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Overrides

    func overrideIndicatorWidth(width: CGFloat) {
        NSLayoutConstraint.deactivate([marginConstraint])
        let constraints = [
            indicatorView.widthAnchor.constraint(equalToConstant: width)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = indicatorView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        indicatorView.backgroundColor = color
    }

}
