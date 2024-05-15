//
//  AmrapView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI
import AVFoundation

struct AmrapView: View {
    @State private var timeRemaining: Int = 600 // Example starting time (10 minutes in seconds)
    @State private var isActive = false // Controls the timer activation
    @State private var progress: CGFloat = 1.0 // For the circular progress view
    @State private var timerDuration: Double = 10.0 // Default duration in minutes for the slider
    @State private var showCompletionImage = false

    @State private var workoutEndPlayer: AVAudioPlayer?

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Full background color

            if showCompletionImage {
                CelebrationView()
            } else {
                VStack {
                    Text("AMRAP")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()

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

                    Text("Duration")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()

                    Slider(value: $timerDuration, in: 1...60, step: 1) {
                        Text("Duration")
                    }
                    .onChange(of: timerDuration) { newValue in
                        timeRemaining = Int(newValue) * 60
                        progress = 1.0
                    }
                    .padding()

                    HStack(spacing: 40) {
                        Button(action: {
                            self.isActive.toggle()
                        }) {
                            Text(isActive ? "PAUSE" : "START")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 30)
                                .background(isActive ? Color.red : Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Button("RESET") {
                            self.resetTimer()
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 30)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            if self.isActive && self.timeRemaining > 0 {
                self.timeRemaining -= 1
                self.progress = CGFloat(self.timeRemaining) / CGFloat(timerDuration * 60)
            } else if self.isActive && self.timeRemaining == 0 {
                self.isActive = false // Stop the timer if it reaches zero
                self.showCompletionImage = true
                self.playSound(named: "workoutEnd")  // Play workout end sound
            }
        }
        .onAppear {
            prepareSoundPlayers()
        }
    }

    func resetTimer() {
        timeRemaining = Int(timerDuration) * 60 // Reset to the initial value from the slider
        progress = 1.0
        isActive = false
        showCompletionImage = false
    }

    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func prepareSoundPlayers() {
        workoutEndPlayer = createPlayer(for: "workoutEnd")
    }

    func createPlayer(for resource: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "mp3") else {
            return nil
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print("Error creating audio player: \(error)")
            return nil
        }
    }

    func playSound(named soundName: String) {
        switch soundName {
        case "workoutEnd":
            workoutEndPlayer?.play()
        default:
            break
        }
    }
}

struct AmrapView_Previews: PreviewProvider {
    static var previews: some View {
        AmrapView()
    }
}
