import Foundation
import Combine
import UIKit

protocol WorkoutTimerProtocol
{
    var timeRemaining: Double { get }
    var isRunning: Bool { get }
    func startWorkout()
    func stopWorkout()
}

class WorkoutVM: ObservableObject, WorkoutTimerProtocol
{
    @Published var timeRemaining: Double = 0  // 🔹 Changed from Int to Double for smooth updates
    @Published var isRunning: Bool = false
    @Published var currentIntervalIndex: Int = 0

    private var displayLink: CADisplayLink?
    private var startTime: TimeInterval?
    private let workout: WorkoutProtocol
    private var lastUpdateTime: TimeInterval?
    private var backgroundTime: TimeInterval?
    
    private let hapticFeedback = UINotificationFeedbackGenerator()

    var currentInterval: Interval?
    {
        guard currentIntervalIndex < workout.intervals.count else { return nil }
        return workout.intervals[currentIntervalIndex]
    }

    init(workout: WorkoutProtocol)
    {
        self.workout = workout
        setupObservers()
        hapticFeedback.prepare()
    }
    
    func displaySets() -> Bool
    {
        return workout.displaySets
    }
    
    func intervalCount() -> Int
    {
        return workout.intervals.count
    }
    
    func getName() -> String
    {
        return workout.name
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    // 🔹 Listen for app backgrounding & foregrounding
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )
    }

    func startWorkout() {
        guard !workout.intervals.isEmpty else { return }
        currentIntervalIndex = 0
        startInterval()
    }

    private func startInterval() {
        guard let interval = currentInterval else {
            stopWorkout()
            return
        }

        timeRemaining = Double(interval.duration) // 🔹 Store as Double for smooth decrement
        isRunning = true
        startTime = CACurrentMediaTime()
        lastUpdateTime = startTime

        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateTimer))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updateTimer() {
        guard let startTime = startTime else { return }
        
        let now = CACurrentMediaTime()
        let elapsed = now - startTime
        
        let newRemaining = max(Double(currentInterval?.duration ?? 0) - elapsed, 0)

        DispatchQueue.main.async {
            self.timeRemaining = newRemaining
        }

        if newRemaining <= 0 {
            hapticFeedback.notificationOccurred(.success)
            nextInterval()
        }
    }

    func nextInterval() {
        currentIntervalIndex += 1
        if currentIntervalIndex >= workout.intervals.count {
            hapticFeedback.notificationOccurred(.warning)
            stopWorkout()
            return
        }
        startInterval()
    }

    func stopWorkout() {
        isRunning = false
        displayLink?.invalidate()
        displayLink = nil
    }

    // 🔹 Handle Background Mode
    @objc private func appWillResignActive() {
        guard isRunning else { return }
        backgroundTime = CACurrentMediaTime()
    }

    @objc private func appDidBecomeActive() {
        guard isRunning, let backgroundTime else { return }

        let elapsedTime = CACurrentMediaTime() - backgroundTime
        timeRemaining = max(timeRemaining - elapsedTime, 0)

        if timeRemaining <= 0 {
            hapticFeedback.notificationOccurred(.success)
            nextInterval()
        }
    }
}
