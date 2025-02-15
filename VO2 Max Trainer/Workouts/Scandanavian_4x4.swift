//
//  Scandanavian_4x4.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//

import Foundation

struct Scandanavian_4x4: WorkoutProtocol
{
    let name: String = "Scandanavian 4x4"
    let intervals: [Interval] =
    [
        Interval(duration: 240, type: .run),
        Interval(duration: 180, type: .rest),
        Interval(duration: 240, type: .run),
        Interval(duration: 180, type: .rest),
        Interval(duration: 240, type: .run),
        Interval(duration: 180, type: .rest),
        Interval(duration: 240, type: .run),
        Interval(duration: 180, type: .rest)
    ]
    let displaySets: Bool = true
}
