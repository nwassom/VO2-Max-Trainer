import UIKit
import AVFoundation
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup background audio
        setupAudioSession()
        
        // Register background tasks
        registerBackgroundTasks()
        
        // Schedule background tasks
        scheduleBackgroundTask() // Add this line
        
        return true
    }
    
    // Setup audio session to allow background audio
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    // Register background tasks
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.VO2 Max Trainer", using: nil) { task in
            // Handle the background task
            self.handleBackgroundTask(task)
        }
    }

    // Handle the background task
    private func handleBackgroundTask(_ task: BGTask) {
        // Perform background updates like refreshing workout timer
        refreshTimerInBackground()
        task.setTaskCompleted(success: true)
    }

    // Function to refresh the timer in the background
    private func refreshTimerInBackground() {
        // Logic to refresh the workout timer or perform updates
        print("Refreshing workout timer in background.")
    }
    
    // Function to schedule background task
    func scheduleBackgroundTask() {
        let request = BGProcessingTaskRequest(identifier: "com.VO2 Max Trainer")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Schedule to run in 15 minutes
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Error scheduling background task: \(error)")
        }
    }
}
