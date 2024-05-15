//
//  EmomView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct EmomView: View {
    @State private var duration: Double = 15  // Default duration set to 15 minutes
    @State private var isActive = false
    @State private var currentRound = 1
    @State private var timeRemaining = 60  // 60 seconds for each round
    @State private var showTimer = false  // To toggle visibility of the circular timer
    @State private var showCompletionImage = false  // To toggle the visibility of the celebration view

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)  // Background color set to black

            if showCompletionImage {
                CelebrationView()
                    .transition(.scale)
            } else {
                VStack {
                    Spacer()
                    
                    Text("EMOM")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()

                    if showTimer {
                        VStack {
                            Text("\(currentRound)/\(Int(duration))")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()

                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 20)
                                    .opacity(0.3)
                                    .foregroundColor(Color.gray)

                                Circle()
                                    .trim(from: 0, to: CGFloat(timeRemaining) / 60.0)
                                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                    .foregroundColor(Color.purple)
                                    .rotationEffect(Angle(degrees: -90))
                                    .animation(.linear, value: timeRemaining)

                                Text("\(timeRemaining)s")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                        }
                    } else {
                        Text("Every minute on the minute for \(Int(duration)) minutes")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()

                        Slider(value: $duration, in: 1...60, step: 1) {
                            Text("Duration")
                        } minimumValueLabel: {
                            Text("1m").foregroundColor(.white)
                        } maximumValueLabel: {
                            Text("60m").foregroundColor(.white)
                        }
                        .padding()
                    }

                    HStack(spacing: 40) {
                        Button(action: {
                            if isActive {
                                isActive = false
                            } else {
                                startTimer()
                            }
                        }) {
                            Text(isActive ? "PAUSE" : "START")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(isActive ? Color.red : Color.green)
                                .clipShape(Capsule())
                        }

                        Button("RESET") {
                            resetTimer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }

                    Spacer()
                }
            }
        }
        .onReceive(timer) { _ in
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timeRemaining = 60  // Reset for next minute
                if currentRound < Int(duration) {
                    currentRound += 1
                } else {
                    isActive = false
                    showTimer = false
                    showCompletionImage = true  // Show the celebration view when all rounds are complete
                }
            }
        }
    }

    func startTimer() {
        isActive = true
        showTimer = true
        showCompletionImage = false  // Ensure celebration view is not shown when restarting the timer
        if currentRound == Int(duration) {
            resetTimer()  // Reset if at the end of the rounds
        }
    }

    func resetTimer() {
        isActive = false
        currentRound = 1
        timeRemaining = 60
        showTimer = false
        showCompletionImage = false  // Hide the celebration view on reset
    }
}

struct EmomView_Previews: PreviewProvider {
    static var previews: some View {
        EmomView()
    }
}
