//
//  Home.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//
import SwiftUI
import SwiftData

struct Home: View {
    @StateObject private var workout = WorkoutVM(workout: Scandanavian_4x4())
    @StateObject private var rest_set = WorkoutVM(workout: Rest_Between_Sets())
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Background Color
            (colorScheme == .dark ? Color(red: 0.02, green: 0.02, blue: 0.1) : Color(red: 0.95, green: 0.95, blue: 0.92))
                .ignoresSafeArea()

            // Centered Button
            TimerButton(viewModel: rest_set)

            // Overlay Text (absolute positioning)
            if workout.displaySets() && workout.isRunning {
                VStack {
                    Text("Set \(workout.currentIntervalIndex)/\(workout.intervalCount())")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .animation(.easeInOut, value: workout.isRunning)
                    Spacer() // Prevents unwanted layout shifts
                }
                .frame(maxHeight: .infinity, alignment: .top) // Positions text at the top without affecting button
                .padding(.top, 50) // Adjust for proper spacing
            }
        }
    }
}

