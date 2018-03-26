//
//  SwitchTableViewCell.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    // MARK: - Properties

    let infoLabel = UILabel()
    let `switch` = UISwitch()

    // MARK: - Initialization

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)//UIFont.systemFont(ofSize: 20, weight: .medium)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoLabel)

        `switch`.translatesAutoresizingMaskIntoConstraints = false
        addSubview(`switch`)

        let constraints = [
            infoLabel.leftAnchor.constraint(equalTo: self.leftAnchor,
                                            constant: CalendarTableViewCell.indentConstant),
            infoLabel.rightAnchor.constraint(equalTo: `switch`.rightAnchor,
                                             constant: -15),

            infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),

            `switch`.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            `switch`.rightAnchor.constraint(equalTo: self.rightAnchor,
                                              constant: -CalendarTableViewCell.indentConstant)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
