//
//  ViewController.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import UIKit

struct HeartRateEvent {
    let event: Event
    let mesaure: HeartRateMeasure
}

class HeartEventCell: UICollectionViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        //        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    let redView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 7
//        view.layer.borderWidth = 3
//        view.layer.borderColor = UIColor(red: 270.0/255.0,
//                                         green: 70.0/255.0,
//                                         blue: 60.0/255.0,
//                                         alpha: 1.0).cgColor

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

                layer.borderWidth = 1
                layer.borderColor = UIColor.lightGray.cgColor

        addSubview(redView)
        redView.addSubview(titleLabel)
        redView.addSubview(dateLabel)
        redView.addSubview(rateLabel)

        let constraints = [
            redView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            redView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            redView.topAnchor.constraint(equalTo: topAnchor),
            redView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leftAnchor.constraint(equalTo: redView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rateLabel.leftAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: redView.centerYAnchor, constant: -10),

            dateLabel.leftAnchor.constraint(equalTo: redView.leftAnchor, constant: 10),
            dateLabel.rightAnchor.constraint(equalTo: rateLabel.leftAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            rateLabel.widthAnchor.constraint(equalToConstant: 120),
            rateLabel.rightAnchor.constraint(equalTo: redView.rightAnchor, constant: -10),
            rateLabel.topAnchor.constraint(equalTo: redView.topAnchor),
            rateLabel.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ViewController: UICollectionViewController {

    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    let eventFetcher = EventFetcher()
    let healthFetcher = HealthFetcher()

    var averageEvent: HeartRateEvent?
    var heartRateEvents = [HeartRateEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(HeartEventCell.self, forCellWithReuseIdentifier: "reuseIdentifier")

        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: view.frame.width, height: 110)

        healthFetcher.authorize { _ in
            self.eventFetcher.authorize { _ in
                self.fetchStuff()
            }
        }

    }

    func fetchStuff() {
        let end = Date()
        let hours = 24 * 4
        let start = end - (1 * TimeInterval(hours) * 60 * 60)

        var heartRateEvents = [HeartRateEvent]()

        // this update logic is messed up
        var newAverage: HeartRateEvent?
        healthFetcher.fetch(start: start, end: end) { measure in
//            newAverage = HeartRateEvent(event: Event(title: "[\(hours) Hours]", start: start, end: end), mesaure: measure)
        }

        let events = eventFetcher.fetch(start: start, end: end)
        for event in events {
            healthFetcher.fetch(start: event.start, end: event.end, completion: { measure in
                heartRateEvents.append(HeartRateEvent(event: event, mesaure: measure))
                if heartRateEvents.count == events.count {
                    self.averageEvent = newAverage
                    self.heartRateEvents = heartRateEvents.sorted(by: { (lhs, rhs) -> Bool in
                        lhs.mesaure.average > rhs.mesaure.average
                    })
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }

                }
            })
        }

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 100 {
            return 1
        } else {
            return heartRateEvents.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseIdentifier", for: indexPath) as? HeartEventCell else {
            fatalError()
        }

        func att(num: Double, txt: String, newLine: Bool = true, aver: Bool = false) -> NSMutableAttributedString {
            let prefix = Int(num).description + " "
            let text = NSMutableAttributedString(string: prefix + txt, attributes: nil)


            let sizeA: CGFloat = aver ? 18 : 18
            let sizeB: CGFloat = aver ? 22 : 22

            let range = NSRange(location: prefix.count, length: txt.count)
            var attributes: [NSAttributedStringKey: Any] = [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: sizeA)
            ]
            text.addAttributes(attributes, range: range)
            attributes = [
                .font: UIFont.systemFont(ofSize: sizeB, weight: .semibold)
            ]
            text.addAttributes(attributes, range: NSRange(location: 0, length: prefix.count))

            if newLine ?? false {
                text.append(NSAttributedString(string: "\n"))
            }
            return text
        }




        var event: HeartRateEvent?

        if indexPath.section == 100 {
            event = averageEvent
        } else {
            event = heartRateEvents[indexPath.row]
        }

        if let event = event {
            cell.titleLabel.text = event.event.title

            let min = att(num: event.mesaure.min, txt: "MIN")
            let ave = att(num: event.mesaure.average, txt: "AVE", newLine: false, aver: true)
            let max = att(num: event.mesaure.max, txt: "MAX", newLine: false)

            min.append(ave)
            min.append(max)

            cell.dateLabel.text = formatter.string(from: event.event.start) + " - " + formatter.string(from: event.event.end)
            cell.rateLabel.attributedText = ave
        } else {

        }
        return cell
    }

    


}

