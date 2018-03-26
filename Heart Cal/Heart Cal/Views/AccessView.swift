//
//  AccessView.swift
//  Heart Cal
//
//  Created by Andrew Finke on 3/25/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

class AccessView: UIView {

    // MARK: - Properties

    var pressed: (() -> Void)?

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 250.0/255.0,
                                         green: 107.0/255.0,
                                         blue: 96.0/255.0,
                                         alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initalization

    override init(frame: CGRect) {
        super.init(frame: .zero)

        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

        addSubview(descriptionLabel)
        addSubview(button)

        let constraints = [
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            button.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            button.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
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

    func disableButton(title: String) {
        button.isEnabled = false
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.75)
        button.setTitle(title, for: .normal)
    }

}
