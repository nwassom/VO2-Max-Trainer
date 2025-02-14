//
//  TimerButton.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/13/25.
//

import SwiftUI

struct TimerButton : View
{
    @State private var isRunning = false
    @State private var timeRemaining = 60
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    
    let totalTime = 60.0
    let notchCount = 60
    
    var body: some View
    {
        
        @StateObject private var viewModel = WorkoutVM(workout: Scandanavian_4x4)
        
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
                    .foregroundColor(filled ? .blue : .gray.opacity(0.3))
            }
            
            Circle()
                .fill(isRunning ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                .frame(width: 200, height: 200)
                .overlay(
                    Text(isRunning ? "\(timeRemaining / 60):\(String(format: "%02d", timeRemaining % 60))" : "Start")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
                .onTapGesture
                {
                    if !isRunning
                    {
                        
                    }
                }
        }
    }
    
    private func startTimer()
    {
        isRunning = true
        progress = 0.0
        timeRemaining = Int(totalTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1 , repeats: true)
        {
            t in
            
            if timeRemaining > 0
            {
                timeRemaining -= 1
                progress = 1.0 - (Double(timeRemaining) / totalTime)
            }
            else
            {
                t.invalidate()
                timer = nil
                isRunning = false
            }
        }
    }
}

struct TimerButtonView_Previews: PreviewProvider
{
    static var previews: some View
    {
            TimerButton()
    }
}
