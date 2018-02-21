//
//  HealthFetcher.swift
//  Heart Cal
//
//  Created by Andrew Finke on 2/7/18.
//  Copyright © 2018 Andrew Finke. All rights reserved.
//

import HealthKit
import UIKit

struct HeartRateMeasure {
    let min: Double
    let max: Double
    let average: Double

    let start: Date
    let end: Date
}

class HealthFetcher: NSObject {

    private let healthStore = HKHealthStore()
    private let heartType: HKQuantityType = {
        guard let object = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            fatalError()
        }
        return object
    }()

    func authorize(completion: @escaping (Bool) -> ()) {
        let set: Set = [heartType]
        healthStore.requestAuthorization(toShare: nil, read: set) { (success, error) in
            completion(success)
        }
    }

    private func storeFetch(start: Date, end: Date, completion: @escaping (HeartRateMeasure) -> ()) {
        let predicate = HKQuery.predicateForSamples(withStart: start,
                                                    end: end,
                                                    options: [.strictStartDate, .strictEndDate])

        let query = HKStatisticsQuery(quantityType: heartType,
                                      quantitySamplePredicate: predicate,
                                      options: [.discreteAverage, .discreteMin, .discreteMax]) { (_, statistics, error) in

                                        guard let statistics = statistics, error == nil else {
                                            fatalError(error.debugDescription)
                                        }
                                        let unit = HKUnit.count().unitDivided(by: HKUnit.minute())

                                        guard let average = statistics.averageQuantity()?.doubleValue(for: unit),
                                            let min = statistics.minimumQuantity()?.doubleValue(for: unit),
                                            let max = statistics.maximumQuantity()?.doubleValue(for: unit) else {
                                                completion(HeartRateMeasure(min: 0,
                                                                            max: 0,
                                                                            average: 0,
                                                                            start: start,
                                                                            end: end))
                                                return
                                        }



                                        let measure = HeartRateMeasure(min: min,
                                                                       max: max,
                                                                       average: average,
                                                                       start: start,
                                                                       end: end)

                                        completion(measure)
        }
        healthStore.execute(query)
    }

    func fetch(start: Date, end: Date, completion: @escaping (HeartRateMeasure) -> ()) {
        storeFetch(start: start, end: end) { (measure) in
            completion(measure)
        }
    }
}

