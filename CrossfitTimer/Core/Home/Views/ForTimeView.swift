//
//  ForTimeView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI
import AVFoundation

struct ForTimeView: View {
    @State private var timeRemaining: Int = 0
    @State private var isActive = false
    @State private var timeCap: Double = 60  // Initial value for time cap in seconds
    @State private var progress: CGFloat = 1.0
    @State private var showCompletionImage = false

    @State private var workoutEndPlayer: AVAudioPlayer?

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)  // Full background color

            if showCompletionImage {
                CelebrationView()
            } else {
                VStack {
                    Spacer()

                    Text(formatTime(timeRemaining))
                        .font(.system(size: 98, weight: .bold))
                        .foregroundColor(.white)

                    Text("TimeCap: ")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                    Text("\(Int(timeCap / 60)) minutes")
                        .font(.title)
                        .foregroundColor(.gray)

                    Slider(value: $timeCap, in: 60...3600, step: 30) { // Slider ranges from 1 minute to 60 minutes
                        Text("Time Cap")
                    } minimumValueLabel: {
                        Text("1m")
                    } maximumValueLabel: {
                        Text("60m")
                    }
                    .foregroundColor(.white)
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

                    Spacer()
                }
            }
        }
        .onReceive(timer) { _ in
            if self.isActive && self.timeRemaining < Int(self.timeCap) {
                self.timeRemaining += 1
                self.progress = CGFloat(self.timeCap - Double(self.timeRemaining)) / CGFloat(self.timeCap)
            } else if self.isActive && self.timeRemaining >= Int(self.timeCap) {
                self.isActive = false  // Stop the timer if it reaches the time cap
                self.showCompletionImage = true
                self.playSound(named: "workoutEnd")  // Play workout end sound
            }
        }
        .onAppear {
            prepareSoundPlayers()
        }
    }

    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func resetTimer() {
        timeRemaining = 0 // Reset to 0
        progress = 1.0
        isActive = false
        showCompletionImage = false
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

struct ForTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ForTimeView()
    }
}
