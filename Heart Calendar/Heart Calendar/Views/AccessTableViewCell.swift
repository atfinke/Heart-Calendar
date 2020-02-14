//
//  AccessTableViewCell.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class AccessTableViewCell: UITableViewCell {

    // MARK: - Properties

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)

        button.setTitleColor(.white, for: .normal)
        button.setTitle("Grant Access", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true

        button.backgroundColor = UIColor(red: 190/255.0,
                                         green: 100/255.0,
                                         blue: 100/255.0,
                                         alpha: 1.0)
        return button
    }()

    static let reuseIdentifier = "reuseIdentifier"

    // MARK: - Initalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)

        let leftMarginConstraint = NSLayoutConstraint(item: titleLabel,
                                                      attribute: .left,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: .leftMargin,
                                                      multiplier: 1.0,
                                                      constant: 0.0)

        let rightMarginConstraint = NSLayoutConstraint(item: titleLabel,
                                                       attribute: .right,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .rightMargin,
                                                       multiplier: 1.0,
                                                       constant: 0.0)

        let constraints = [
            leftMarginConstraint,
            rightMarginConstraint,
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),

            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            button.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            button.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
