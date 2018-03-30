//
//  AccessView.swift
//  Heart Calendar
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class AccessView: UIView {

    // MARK: - Properties

    var pressed: (() -> Void)?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 54.0/255.0, green: 54.0/255.0, blue: 54.0/255.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Grant Access", for: .normal)
        button.backgroundColor = UIColor(red: 190/255.0,
                                         green: 100/255.0,
                                         blue: 100/255.0,
                                         alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initalization

    override init(frame: CGRect) {
        super.init(frame: .zero)

        let lineView = UILabel()
        lineView.backgroundColor = UIColor.lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lineView)

        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(button)

        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            lineView.heightAnchor.constraint(equalToConstant: 2),
            lineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            lineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lineView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            button.heightAnchor.constraint(equalToConstant: 45),
            button.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            button.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Other

    @objc
    func buttonPressed() {
        pressed?()
    }

    func disableButton() {
        button.isEnabled = false
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
    }

}
