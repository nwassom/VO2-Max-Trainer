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
    @StateObject private var viewModel = WorkoutVM(workout: Scandanavian_4x4())
    @State private var displayProgress: Double = 0.0;
    
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
                    .foregroundColor(filled ? .blue : .blue.opacity(0.3))
            }
            
            Circle()
                .fill(viewModel.isRunning ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: 300, height: 300)
                .overlay(
                    Text(viewModel.isRunning ? "\(formattedTime(viewModel.timeRemaining))" : "Start")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
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
            TimerButton()
    }
}
