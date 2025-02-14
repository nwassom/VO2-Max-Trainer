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
    
    private var timer: Timer?
    private var intervals: [Interval] = []
    private var currentIntervalIndex = 0
    
    init(workout: WorkoutProtocol)
    {
        self.intervals = workout.intervals
    }
    
    func startWorkout() {
        guard !intervals.isEmpty else { return }
        currentIntervalIndex = 0
        startInterval()
    }
    
    private func startInterval()
    {
        guard currentIntervalIndex < intervals.count else
        {
            stopWorkout()
            return
        }
        
        let interval = intervals[currentIntervalIndex]
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





