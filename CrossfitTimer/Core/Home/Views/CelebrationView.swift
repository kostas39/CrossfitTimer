//
//  CelebrationView.swift
//  CrossfitTimer
//
//  Created by Kostas Koliolios on 11/05/2024.
//

import SwiftUI

struct CelebrationView: View {
    var body: some View {
        ZStack {
            ConfettiView()
                .background(Color.black.opacity(0.8).edgesIgnoringSafeArea(.all))
            VStack {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                Text("You did it!")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ConfettiView: View {
    let confettiColors: [Color] = [.red, .green, .blue, .yellow, .pink, .purple, .orange]
    let confettiSizes: [CGSize] = [CGSize(width: 10, height: 10), CGSize(width: 15, height: 15), CGSize(width: 20, height: 20)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<100, id: \.self) { index in
                    ConfettiPiece(color: confettiColors[index % confettiColors.count],
                                  size: confettiSizes[index % confettiSizes.count],
                                  screenWidth: geometry.size.width,
                                  screenHeight: geometry.size.height)
                }
            }
        }
    }
}

struct ConfettiPiece: View {
    var color: Color
    var size: CGSize
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    @State private var isAnimating = false

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size.width, height: size.height)
            .position(x: CGFloat.random(in: 0...screenWidth), y: isAnimating ? screenHeight + size.height : -size.height) // Starting and ending y positions
            .rotationEffect(.degrees(Double.random(in: 0...360)))
            .animation(Animation.interpolatingSpring(stiffness: 50, damping: 1).repeatForever().speed(Double.random(in: 0.2...1)).delay(Double.random(in: 0...2)), value: isAnimating)
            .onAppear() {
                self.isAnimating = true
            }
    }
}

struct CelebrationView_Previews: PreviewProvider {
    static var previews: some View {
        CelebrationView()
    }
}
