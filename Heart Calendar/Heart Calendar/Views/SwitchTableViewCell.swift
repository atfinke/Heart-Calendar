//
//  SwitchTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    // MARK: - Properties

    let infoLabel = UILabel()
    let preferenceSwitch = UISwitch()
    static let reuseIdentifier = "switchReuseIdentifier"

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoLabel)

        preferenceSwitch.translatesAutoresizingMaskIntoConstraints = false
        addSubview(preferenceSwitch)

        let leftMarginConstraint = NSLayoutConstraint(item: infoLabel,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .leftMargin,
                                                      multiplier: 1.0,
                                                      constant: 0.0)

        let rightMarginConstraint = NSLayoutConstraint(item: preferenceSwitch,
                                                      attribute: .right,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .rightMargin,
                                                      multiplier: 1.0,
                                                      constant: 0.0)

        let constraints = [
            leftMarginConstraint,
            infoLabel.rightAnchor.constraint(equalTo: preferenceSwitch.rightAnchor,
                                             constant: -15),

            infoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            infoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),

            preferenceSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightMarginConstraint
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
