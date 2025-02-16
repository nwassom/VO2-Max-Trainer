import SwiftUI

struct TimerButton: View {
    @ObservedObject private var viewModel: WorkoutVM
    @State private var displayProgress: Double = 0.0
    
    init(viewModel: WorkoutVM) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Extract static circle into separate view
            StaticCircle()
            
            // Extract progress circle into separate view
            ProgressCircle(progress: displayProgress)
            
            // Extract center button into separate view
            CenterButton(
                isRunning: viewModel.isRunning,
                timeRemaining: viewModel.timeRemaining,
                workoutName: viewModel.getName(),
                onTap: { if !viewModel.isRunning { viewModel.startWorkout() } }
            )
        }
        .onChange(of: viewModel.timeRemaining) { _ in
            animateProgress()
        }
    }
    
    private func animateProgress() {
        let newProgress = progress()
        withAnimation(.linear(duration: 0.1)) {
            displayProgress = newProgress
        }
    }
    
    private func progress() -> Double {
        guard let currentInterval = viewModel.currentInterval else { return 0.0 }
        return 1.0 - (Double(viewModel.timeRemaining) / Double(currentInterval.duration))
    }
}

// MARK: - Subcomponents

private struct StaticCircle: View {
    var body: some View {
        Circle()
            .stroke(Color.blue.opacity(0.3))
            .frame(width: 300, height: 300)
            .shadow(color: Color.cyan.opacity(0.8), radius: 10)
    }
}

private struct ProgressCircle: View {
    let progress: Double
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(
                Color.cyan,
                style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .frame(width: 300, height: 300)
            .animation(.linear(duration: 0.1), value: progress)
    }
}

private struct CenterButton: View {
    let isRunning: Bool
    let timeRemaining: Double
    let workoutName: String
    let onTap: () -> Void
    
    var body: some View {
        Circle()
            .fill(isRunning ? Color.blue.opacity(0.3) : Color.green.opacity(0.3))
            .frame(width: 300, height: 300)
            .overlay(buttonContent)
            .overlay(buttonBorder)
            .scaleEffect(isRunning ? 1.05 : 1)
            .animation(.easeInOut(duration: 0.2), value: isRunning)
            .onTapGesture(perform: onTap)
    }
    
    private var buttonContent: some View {
        VStack {
            Text(isRunning ? formattedTime(Int(timeRemaining)) : "Start\n\(workoutName)")
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 8)
        }
    }
    
    private var buttonBorder: some View {
        Circle()
            .stroke(isRunning ? Color.blue : Color.green, lineWidth: 4)
            .opacity(0.5)
    }
    
    private func formattedTime(_ seconds: Int) -> String {
        return "\(seconds / 60):\(String(format: "%02d", seconds % 60))"
    }
}

// MARK: - Preview
struct TimerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = WorkoutVM(workout: Scandanavian_4x4())
        TimerButton(viewModel: workout)
    }
}
