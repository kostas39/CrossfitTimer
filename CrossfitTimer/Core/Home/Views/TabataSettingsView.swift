//
//  TabataSettingsView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 14/05/2024.
//

import SwiftUI

struct TabataSettingsView: View {
    @Binding var exerciseSeconds: Double
    @Binding var restSeconds: Double
    @Binding var numberOfRounds: Double
    @Binding var soundAlerts: Bool
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title)
                }
                .padding()
            }

            Text("Tabata Settings")
                .font(.title)
                .foregroundColor(.white)
                .padding()

            ScrollView {
                VStack(spacing: 20) {
                    Toggle(isOn: $soundAlerts) {
                        Text("Sound Alerts")
                            .foregroundColor(.white)
                    }
                    .padding()

                    VStack(spacing: 20) {
                        HStack {
                            Text("Exercise: \(Int(exerciseSeconds)) seconds")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $exerciseSeconds, in: 5...60)
                                .labelsHidden()
                        }
                        .padding()

                        Slider(value: $exerciseSeconds, in: 5...60, step: 1)
                            .accentColor(.white)
                            .padding()

                        HStack {
                            Text("Rest: \(Int(restSeconds)) seconds")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $restSeconds, in: 5...60)
                                .labelsHidden()
                        }
                        .padding()

                        Slider(value: $restSeconds, in: 5...60, step: 1)
                            .accentColor(.white)
                            .padding()

                        HStack {
                            Text("Rounds: \(Int(numberOfRounds))")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $numberOfRounds, in: 1...20)
                                .labelsHidden()
                        }
                        .padding()

                        Slider(value: $numberOfRounds, in: 1...20, step: 1)
                            .accentColor(.white)
                            .padding()
                    }
                    .padding()
                }
            }
        }
        .background(Color.black)
        .cornerRadius(20)
        .edgesIgnoringSafeArea(.all)
    }
}




