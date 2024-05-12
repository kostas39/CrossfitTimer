//
//  EmomView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 09/05/2024.
//

import SwiftUI

struct EmomView: View {
    @State private var duration: Double = 10  // Default duration set to 10 minutes

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)  // Set the background color to black

            VStack {
                Spacer()
                
                Text("EMOM")
                    .font(.largeTitle)
                    .foregroundColor(.white)  // Set text color to white for visibility on black background
                    .padding()

                Text("Every minute on the minute for \(Int(duration)) minutes")
                    .font(.title)
                    .foregroundColor(.white)  // Set text color to white for visibility
                    .padding()

                Slider(value: $duration, in: 1...60, step: 1) {
                    Text("Duration")
                } minimumValueLabel: {
                    Text("1m").foregroundColor(.white)
                } maximumValueLabel: {
                    Text("60m").foregroundColor(.white)
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct EmomView_Previews: PreviewProvider {
    static var previews: some View {
        EmomView()
    }
}


