//
//  VO2_Max_TrainerApp.swift
//  VO2 Max Trainer
//
//  Created by Nick Wassom on 2/11/25.
//

import SwiftUI
import SwiftData

@main
struct VO2_Max_TrainerApp: App
{
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene
    {
        WindowGroup
        {
            Home()
        }
    }
}

