//
//  Workout.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//

import Foundation

protocol WorkoutProtocol
{
    var name: String {get}
    var intervals: [Interval] {get}
    var displaySets: Bool {get}
}
