//
//  HomeView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isActiveEmom = false
    @State private var isActiveAmrap = false
    @State private var isActiveForTime = false
    @State private var isActiveTabata = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)  // Background color
                VStack(spacing: 30) {  // Adjust spacing between elements in the VStack
                    Text("Choose your workout")
                        .font(.largeTitle)  // Makes the text larger and more prominent
                        .fontWeight(.bold)  // Makes the text bold
                        .foregroundColor(.white)  // Sets the text color to white
                        .padding(.top, 20)  // Adds padding on the top for the headline

                    Button("EMOM") {
                        isActiveEmom = true
                    }
                    .buttonStyle(TimerButtonStyle(backgroundColor: .red))
                    .background(
                        NavigationLink(destination: EmomView(), isActive: $isActiveEmom) {
                            EmptyView()
                        }
                        .hidden()
                    )
                    
                    Button("AMRAP") {
                        isActiveAmrap = true
                    }
                    .buttonStyle(TimerButtonStyle(backgroundColor: .purple))
                    .background(
                        NavigationLink(destination: AmrapView(), isActive: $isActiveAmrap) {
                            EmptyView()
                        }
                        .hidden()
                    )

                    Button("4 TIME") {
                        isActiveForTime = true
                    }
                    .buttonStyle(TimerButtonStyle(backgroundColor: .blue))
                    .background(
                        NavigationLink(destination: ForTimeView(), isActive: $isActiveForTime) {
                            EmptyView()
                        }
                        .hidden()
                    )

                    Button("TABATA") {
                        isActiveTabata = true
                    }
                    .buttonStyle(TimerButtonStyle(backgroundColor: .green))
                    .background(
                        NavigationLink(destination: TabataView(), isActive: $isActiveTabata) {
                            EmptyView()
                        }
                        .hidden()
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())  // Ensure stack navigation style on all devices
    }
}

struct TimerButtonStyle: ButtonStyle {
    var backgroundColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
