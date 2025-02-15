//
//  Rest_Between_Sets.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//

import Foundation

struct Rest_Between_Sets: WorkoutProtocol
{
    let name: String = "Rest"
    let intervals: [Interval] =
    [
        Interval(duration: 120, type: .rest)
    ]
    let displaySets: Bool = false
}
