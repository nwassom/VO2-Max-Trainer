//
//  Interval.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//

import Foundation

enum IntervalType
{
    case run, rest
}

struct Interval
{
    let duration: Int // in seconds
    let type: IntervalType
}
