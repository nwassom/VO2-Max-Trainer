//
//  Home.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/14/25.
//
import SwiftUI
import SwiftData

struct Home: View {
    @State private var showMenu = false
    @StateObject private var workout = WorkoutVM(workout: Scandanavian_4x4())
    @StateObject private var rest_set = WorkoutVM(workout: Rest_Between_Sets())

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Background Color (Tappable to Toggle Menu)
            (colorScheme == .dark ? Color(red: 0.02, green: 0.02, blue: 0.1) : Color(red: 0.95, green: 0.95, blue: 0.92))
                .ignoresSafeArea()
                .onTapGesture {
                    // Only toggle menu if workout is NOT running
                    if !workout.isRunning {
                        withAnimation(.spring()) {
                            showMenu.toggle()
                        }
                    }
                }
                .disabled(workout.isRunning) // Disable background tap gesture if workout is running

            // Centered Button (Does Not Trigger Menu)
            VStack {
                Spacer()
                TimerButton(viewModel: rest_set)
                Spacer()
            }

            // Overlay Text at the Top
            if workout.displaySets() && workout.isRunning {
                VStack {
                    Text("Set \(workout.currentIntervalIndex)/\(workout.intervalCount())")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .animation(.easeInOut, value: workout.isRunning)
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 50)
            }

            // Bottom Menu - Only show when workout is NOT running
            if !workout.isRunning && showMenu {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        menuView
                            .transition(.move(edge: .bottom)) // Slide-in effect
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.black.opacity(0.2)) // Dim background
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showMenu = false
                        }
                    }
                }
            }
        }
    }
    // Menu View
    private var menuView: some View {
        VStack(spacing: 16) {
            Text("Menu 1").padding()
            Text("Menu 2").padding()
            Text("Menu 3").padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(20)
    }
}

