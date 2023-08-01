//
//  TimedEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import AVFoundation

struct TimedEquations: View {
    @State var timeRemaining = 60
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @AppStorage("correct") private var timedHighScore = -1
    @State var sessionScore = 0
    @State var sliderValue: Float = 2.0
    @State var ratioIC = "N/A"
    @State var attempts: Int = 0
    @State var settings: Int = 0
    @State var equations = false
    @Environment(\.presentationMode) var presentationMode
    @State var answer = ""
    @State var timer = -1
    @State var text = "Begin"
    @State var currentInfo = equationInfo(terms: [Int](), answer: 0, displayText: "")
    var body: some View {


        VStack {
            Image(systemName: "clock.fill")
                .imageScale(.large)
                .foregroundColor(.red)
            Text("60 Seconds!")
            Divider()
                .frame(width: 200)
            if !equations{
                Text("Term Count:")
                    .font(.headline)
                Text("\(Int(sliderValue))").font(.title2).fontWeight(.thin)
                Slider(value: $sliderValue, in: 2...5) {
                } minimumValueLabel: {
                    Text("2").font(.callout).fontWeight(.thin)
                } maximumValueLabel: {
                    Text("5").font(.callout).fontWeight(.thin)
                }
                .frame(width: 125, height: 5)
                
                if timedHighScore != -1{
                    Text("High Score:")
                    Text("\(timedHighScore)").font(.title2).fontWeight(.thin)
                }
            }
            if equations {
                Text(String(timeRemaining))
                    .font(.largeTitle)
                    .onReceive(countdown){ time in
                        if timeRemaining > 0 {
                            
                            timeRemaining -= 1
                        }else{
                            if equations{
                                equations = false
                                text = "Begin"
                            } else {
                                equations = true
                                text = "End"
                            }
                            if sessionScore > timedHighScore{
                                timedHighScore = sessionScore
                            }
                        }
                    }
                Text(currentInfo.displayText)
                TextField("Answer", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 125)
                    .modifier(jiggleEffect(animatableData: CGFloat(attempts)))
                    .multilineTextAlignment(.center)
                Button("Submit"){
                    if answer == String(currentInfo.answer){
                        sessionScore += 1
                        currentInfo = equationShuffle(termCount: Int(sliderValue))
                        answer = ""
                    } else {
                        withAnimation(.default){
                            attempts += 1
                            answer = ""
                        }
                    }
                }
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            Button("\(text)") {
                if equations{
                    equations = false
                    text = "Begin"
                    
                    // Check if user has a score higher than their previous, if so, updates their high score.
                    if sessionScore > timedHighScore{
                        timedHighScore = sessionScore
                    }
                } else {
                    equations = true
                    text = "End"
                    sessionScore = 0
                    currentInfo = equationShuffle(termCount: Int(sliderValue))
                    timeRemaining = 60
                }
            }
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            if !equations{
                Button("Back"){
                    presentationMode.wrappedValue.dismiss()
                }
                .accentColor(.red)
                
            }
            Keypad()
            }
        }
    }
struct KeyButton: View {
    @State private var isAnimating = false
    @GestureState private var isDetectingLongPress = false
    @State private var isLongPressing = false // Additional state property

    var text: String

    var body: some View {
        let longPress = LongPressGesture(minimumDuration: 0.01)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
                isLongPressing = currentState // Update the additional state property
            }
            .onEnded { _ in
                withAnimation(.spring()) {
                    isAnimating = false
                }
                isLongPressing = false // Reset the long press state after the gesture is completed
            }

        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .circular)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 4)
                )
                .frame(width: isAnimating ? 70 : 80, height: isAnimating ? 70 : 80)
                .scaleEffect(isLongPressing ? 0.8 : 1.0) // Apply the scaling effect on tap

            Text(text)
                .bold()
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.gray)
        }
        .gesture(
            longPress
                .onChanged { isPressing in
                    withAnimation(.spring()) {
                        isAnimating = isPressing // Apply the scaling effect when pressing
                    }
                }
        )
        .animation(.spring()) // Apply animation to the whole view
    }
}

struct Keypad: View {
    var body: some View {
        VStack {
            HStack {
                KeyButton(text: "1")

                KeyButton(text: "2")

                KeyButton(text: "3")
            }
        }
    }
}
