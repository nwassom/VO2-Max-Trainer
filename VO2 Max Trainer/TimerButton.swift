//
//  TimerButton.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/13/25.
//

import SwiftUI

struct TimerButton : View
{
    @StateObject private var viewModel = WorkoutVM(workout: Scandanavian_4x4())
    
    let notchCount = 60
    
    var body: some View
    {
        ZStack
        {
            ForEach (0..<notchCount, id: \.self)
            {
                i in
                
                let angle = Angle(degrees: (Double(i) / Double(notchCount)) * 360.0)
                let filled = Double(i) / Double(notchCount) <= progress
                
                Rectangle()
                    .frame(width: 4, height: 15)
                    .offset(y: -90)
                    .rotationEffect(angle)
                    .foregroundColor(filled ? .blue : .blue.opacity(0.3))
            }
            
            Circle()
                .fill(viewModel.isRunning ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: 200, height: 200)
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
