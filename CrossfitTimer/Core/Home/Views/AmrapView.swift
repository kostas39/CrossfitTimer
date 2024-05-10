//
//  AmrapView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct AmrapView: View {
    @State private var timeRemaining: Int = 600 // Example starting time (10 minutes in seconds)
    @State private var isActive = false // Controls the timer activation
    @State private var progress: CGFloat = 1.0 // For the circular progress view

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Full background color

            VStack {
                ZStack {
                    Circle() // Background circle
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)

                    Circle() // Foreground circle
                        .trim(from: 0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(Color.purple)
                        .rotationEffect(Angle(degrees: -90)) // Start from top
                        .animation(.linear, value: progress)

                    Text(formatTime(timeRemaining))
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 200)
                .padding()

                HStack {
                    Button(action: {
                        self.isActive.toggle()
                    }) {
                        Text(isActive ? "PAUSE" : "START")
                            .foregroundColor(.white)
                            .padding()
                            .background(isActive ? Color.red : Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    Button("RESET") {
                        self.resetTimer()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .onReceive(timer) { _ in
            if self.isActive && self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.progress = CGFloat(self.timeRemaining) / 600.0 // Adjust the progress based on total time
            }
        }
    }

    func resetTimer() {
        timeRemaining = 600 // Reset to 10 minutes
        progress = 1.0
        isActive = false
    }

    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}




#Preview {
    AmrapView()
}
