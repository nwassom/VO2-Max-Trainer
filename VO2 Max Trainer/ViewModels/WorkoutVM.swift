//
//  WorkoutVM.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//

import Foundation
import Combine

protocol WorkoutTimerProtocol
{
    var timeRemaining: Int {get}
    var isRunning: Bool {get}
    func startWorkout()
    func stopWorkout()
}

class WorkoutVM: ObservableObject, WorkoutTimerProtocol
{
    @Published var timeRemaining: Int = 0
    @Published var isRunning: Bool = false
    @Published var currentIntervalIndex: Int = 0
    
    private var timer: Timer?
    private let workout: WorkoutProtocol
    
    var currentInterval: Interval?
    {
        guard currentIntervalIndex < workout.intervals.count else { return nil }
        return workout.intervals[currentIntervalIndex]
    }
    
    init(workout: WorkoutProtocol)
    {
        self.workout = workout
    }
    
    func startWorkout() {
        guard !workout.intervals.isEmpty else { return }
        currentIntervalIndex = 0
        startInterval()
    }
    
    private func startInterval()
    {
        guard let interval = currentInterval else
        {
            stopWorkout()
            return
        }
        
        timeRemaining = interval.duration
        isRunning = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        {
            [weak self] _ in
            
            guard let self = self else { return }
            
            if self.timeRemaining > 0
            {
                self.timeRemaining -= 1
            }
            else
            {
                self.nextInterval()
            }
        }
    }
    
    func nextInterval()
    {
        currentIntervalIndex += 1
        startInterval()
    }
    
    func stopWorkout()
    {
        timer?.invalidate()
        isRunning = false
    }
}





