//
//  UIElements.swift
//  impracticalint
//
//  Created by David G on 8/11/23.
//

import SwiftUI
import AVFoundation

struct AnimatedCheckmarkView: View {
    @Binding var isAnimating: Bool
    
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.system(size: 60))
            .opacity(isAnimating ? 1.0 : 0.0)
            .scaleEffect(isAnimating ? 1.0 : 0.2)
            .animation(
                isAnimating ?
                    Animation.spring(response: 0.5, dampingFraction: 0.5)
                    : .default
            )
            .onAppear {
                if isAnimating {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isAnimating = false
                    }
                }
            }
    }
}

struct Keypad: View {
    @Binding var answer: String
    @Binding var attempts: Int
    let systemSoundID: SystemSoundID = 1306

    var endGame: () -> Void

    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(1...3, id: \.self) { number in
                        Button(action: {
                            AudioServicesPlaySystemSound(systemSoundID)
                            answer += "\(number + row * 3)"
                        }) {
                            Text("\(number + row * 3)")
                        }
                        .buttonStyle(KeyButton())
                    }
                }
            }
            HStack {
                Button(action: {
                    AudioServicesPlaySystemSound(systemSoundID)
                    answer += "-"
                }) {
                    Text("-")
                }
                .buttonStyle(KeyButton())
                Button(action: {
                    AudioServicesPlaySystemSound(systemSoundID)
                    answer += "0"
                }) {
                    Text("0")
                }
                .buttonStyle(KeyButton())
                Button(action: {
                    AudioServicesPlaySystemSound(systemSoundID)
                    answer = ""
                    withAnimation(.default) {
                        attempts += 1
                        answer = ""
                    }
                }) {
                    Text("C")
                }
                .buttonStyle(KeyButton())
            }
            Button("End") {
                endGame()
            }
            .frame(width: 245, height: 75)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .circular)
                    .foregroundColor(Color("buttonBackground"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("foregroundTwo"), lineWidth: 4)
                    )
            )
            .foregroundColor(Color("foregroundTwo"))
            .font(.title)
            .fontWeight(.heavy)
            .animation(.spring())
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        .transition(.slideInFromBottom)
    }
}

struct LabelledDivider: View {
    
    let label: String
    let horizontalPadding: CGFloat
    let color: Color
    
    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }
    
    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }
    
    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}
