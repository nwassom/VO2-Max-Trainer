//
//  TimerButton.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/13/25.
//

import SwiftUI

/*
    - Implement smoother transitions on notches
    - Color change depending on rest vs run
    - Background app refresh so that if phone locked still updates
    - Live updates
 
    - Siri / Voice integration for transitions
 */
struct TimerButton : View
{
    @ObservedObject private var viewModel: WorkoutVM
    @State private var displayProgress: Double = 0.0
    
    init(viewModel: WorkoutVM)
    {
        self.viewModel = viewModel
    }
    
    var body: some View
    {
        ZStack
        {
            ForEach (0..<notchCount, id: \.self)
            {
                i in
                
                let angle = Angle(degrees: (Double(i) / Double(notchCount)) * 360.0)
                let filled = Double(i) / Double(notchCount) <= displayProgress
                
                Rectangle()
                    .frame(width: 4, height: 15)
                    .offset(y: -135)
                    .rotationEffect(angle)
                    .foregroundColor(filled ? Color(red: 0, green: 1, blue: 1) : Color.blue.opacity(0.3)) // Nuka-Cola Blue
                    .shadow(color: Color.cyan.opacity(0.8), radius: 10) // Outer glow effect

            }
            
            Circle()
                .fill(viewModel.isRunning ? Color.blue.opacity(0.3) : Color.green.opacity(0.3))  // Adaptive colors
                .frame(width: 300, height: 300, alignment: .center)
                .overlay(
                    Text(viewModel.isRunning ? "\(formattedTime(viewModel.timeRemaining))" : "Start\n\(viewModel.getName())")
                        .font(.system(size: 36, weight: .medium))  // Minimalistic font style
                        .foregroundColor(.white)  // Clean white text
                        .shadow(color: Color.black.opacity(0.5), radius: 8)  // Subtle shadow to enhance visibility
                )
                .overlay(
                    Circle()  // Add a subtle border
                        .stroke(viewModel.isRunning ? Color.blue : Color.green, lineWidth: 4)
                        .opacity(0.5)
                )
                .padding()  // Spacing from surrounding elements
                .background(
                    (Color.black.opacity(0.05) // Light background effect for dark mode
                        .cornerRadius(300)) // Circular background effect
                )
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5) // Button shadow
                .scaleEffect(viewModel.isRunning ? 1.05 : 1)  // Subtle scale effect when running
                .animation(.easeInOut(duration: 0.2), value: viewModel.isRunning)  // Smooth animation
                .onTapGesture
                {
                    if !viewModel.isRunning
                    {
                        viewModel.startWorkout()
                    }
                }
            }
        .onChange(of: viewModel.timeRemaining, initial: true)
        {
            _,_ in
            animateProgress()
        }
    }
    
    private var notchCount: Int
    {
        guard let duration = viewModel.currentInterval?.duration else { return 60 }
        
        let minNotches = 60
        let maxNotches = 120
        let scaleFactor = 2.0
        
        let scaledNotches = minNotches + Int(Double(duration) / scaleFactor)
        
        return min(max(scaledNotches, minNotches), maxNotches)
    }
    
    private func animateProgress()
    {
        withAnimation(.linear(duration: 0.1))
        {
            displayProgress = progress
        }
    }
    private var progress: Double
    {
        guard let currentInterval = viewModel.currentInterval else { return 0.0 }
        return 1.0 - (Double(viewModel.timeRemaining) / Double(currentInterval.duration))
    }
    
    private func formattedTime(_ seconds: Int) -> String
    {
        return "\(seconds / 60):\(String(format: "%02d", seconds % 60))"
    }
}

struct TimerButtonView_Previews: PreviewProvider
{
    static var previews: some View
    {
        var workout = WorkoutVM(workout: Scandanavian_4x4())
        TimerButton(viewModel: workout)
    }
}
