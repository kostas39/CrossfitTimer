//
//  TabataView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct TabataView: View {
    @State private var timeRemaining: Int = 0 // Timer duration in seconds
    @State private var exerciseSeconds: Double = 20
    @State private var restSeconds: Double = 10
    @State private var numberOfRounds: Double = 8
    @State private var soundAlerts: Bool = true
    @State private var showingSettings = false // State to control the settings sheet

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Full screen background color

            VStack {
                Spacer()
                
                Text("EXERCISE")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                ZStack {
                    Circle() // Background circle
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)

                    Circle() // Foreground circle
                        .trim(from: 0, to: 0) // Start empty
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.purple)
                        .rotationEffect(Angle(degrees: 270)) // Start from the top

                    Text(timeString(from: timeRemaining))
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)

                HStack(spacing: 40) {
                    // Settings Button
                    Button("SETTINGS") {
                        showingSettings.toggle() // Show settings sheet
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Capsule())

                    // Start Button
                    Button("START") {
                        // Action to start the timer
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(Capsule())
                }

                Spacer()
            }
        }
        .sheet(isPresented: $showingSettings) {
            TabataSettingsView(
                exerciseSeconds: $exerciseSeconds,
                restSeconds: $restSeconds,
                numberOfRounds: $numberOfRounds,
                soundAlerts: $soundAlerts,
                isPresented: $showingSettings
            )
        }
    }

    // Helper function to convert time in seconds to a formatted string
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TabataView_Previews: PreviewProvider {
    static var previews: some View {
        TabataView()
    }
}


