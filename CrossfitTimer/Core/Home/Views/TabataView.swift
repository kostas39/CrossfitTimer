//
//  TabataView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct TabataView: View {
    @State private var exerciseSeconds: Double = 20
    @State private var restSeconds: Double = 10
    @State private var numberOfRounds: Double = 8
    @State private var soundAlerts: Bool = true
    @State private var isActive = false
    @State private var timeRemaining = 0
    @State private var currentRound = 1
    @State private var isExercisePhase = true
    @State private var showSettings = false
    @State private var showCompletionImage = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text(isExercisePhase ? "EXERCISE" : "REST")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()

                Text("Round \(currentRound)/\(Int(numberOfRounds))")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)

                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(isExercisePhase ? exerciseSeconds : restSeconds))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .foregroundColor(isExercisePhase ? Color.green : Color.red)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.linear, value: timeRemaining)

                    Text("\(timeString(from: timeRemaining))")
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                }
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)

                VStack(spacing: 20) {
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

                        Button("SETTINGS") {
                            showSettings.toggle()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }

                    Button("RESET") {
                        resetTimer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 30)
                    .background(Color.orange)
                    .clipShape(Capsule())
                }

                Spacer()
            }
        }
        .sheet(isPresented: $showSettings) {
            // Assuming you have a separate TabataSettingsView
            TabataSettingsView(
                exerciseSeconds: $exerciseSeconds,
                restSeconds: $restSeconds,
                numberOfRounds: $numberOfRounds,
                soundAlerts: $soundAlerts,
                isPresented: $showSettings
            )
        }
        .onReceive(timer) { _ in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                if isExercisePhase {
                    isExercisePhase = false
                    timeRemaining = Int(restSeconds)
                } else {
                    if currentRound < Int(numberOfRounds) {
                        currentRound += 1
                        isExercisePhase = true
                        timeRemaining = Int(exerciseSeconds)
                    } else {
                        isActive = false
                        showCompletionImage = true
                    }
                }
            }
        }
    }

    func startTimer() {
        if timeRemaining == 0 && !isActive {
            timeRemaining = Int(exerciseSeconds)
            currentRound = 1
            isExercisePhase = true
            showCompletionImage = false
        }
        isActive = true
    }

    func resetTimer() {
        isActive = false
        timeRemaining = Int(exerciseSeconds)
        currentRound = 1
        isExercisePhase = true
        showCompletionImage = false
    }

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
