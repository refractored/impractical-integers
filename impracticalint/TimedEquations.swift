//
//  TimedEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import AVFoundation

extension AnyTransition {
    static var slideInFromBottom: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: .identity)
    }
    
    static var slideOutToBottom: AnyTransition {
        let removal = AnyTransition.move(edge: .bottom).combined(with: .opacity)
        return .asymmetric(insertion: .identity, removal: removal)
    }
}


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
    let buttonBackground = Color("buttonBackground")
    @State var currentInfo = equationInfo(terms: [Int](), answer: 0, displayText: "")
    var body: some View {
        
        
        VStack {
            
            if !equations{
                Image(systemName: "clock.fill")
                    .imageScale(.large)
                    .foregroundColor(buttonBackground)
                VStack {
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
            }
            
            if equations {
                VStack{
                    Image(systemName: "clock.fill")
                        .imageScale(.large)
                        .foregroundColor(buttonBackground)
                    Text(String(timeRemaining))
                        .font(.largeTitle)
                        .fontWeight(.heavy)
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
                                    // .foregroundColor(.red)
                                }
                                if sessionScore > timedHighScore{
                                    timedHighScore = sessionScore
                                }
                            }
                        }
                    Text(currentInfo.displayText)
                    TextField("Answer", text: $answer)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .modifier(jiggleEffect(animatableData: CGFloat(attempts)))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                        .tint(buttonBackground)
                }
                .transition(.slideInFromBottom)
                .animation(.spring())
            }
            if !equations{
                Button("\(text)") {
                    equations = true
                    sessionScore = 0
                    currentInfo = equationShuffle(termCount: Int(sliderValue))
                    timeRemaining = 60
                }
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
            }
            if !equations{
                Button("Back"){
                    presentationMode.wrappedValue.dismiss()
                }
                .accentColor(buttonBackground)
                
            }
            
        }
        if equations {
            VStack {
                HStack {
                    Button(action: {
                        answer += "1"
                    }) {
                        Text("1")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        answer += "2"
                    }) {
                        Text("2")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        answer += "3"
                    }) {
                        Text("3")
                    }
                    .buttonStyle(KeyButton())
                }
                HStack {
                    Button(action: {
                        answer += "4"
                    }) {
                        Text("4")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        answer += "5"
                    }) {
                        Text("5")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        answer += "6"
                    }) {
                        Text("6")
                    }
                    .buttonStyle(KeyButton())
                }
                HStack {
                    Button(action: {
                        answer += "7"
                    }) {
                        Text("7")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        answer += "8"
                    }) {
                        Text("8")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        answer += "9"
                    }) {
                        Text("9")
                    }
                    .buttonStyle(KeyButton())
                }
                HStack {
                    Button(action: {
                        answer += "-"
                    }) {
                        Text("-")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        answer = ""
                        withAnimation(.default){
                            attempts += 1
                            answer = ""
                        }
                        
                    }) {
                        Text("C")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        withAnimation(.none) {
                            equations = false
                        }
                        if sessionScore > timedHighScore {
                            timedHighScore = sessionScore
                        }
                    }) {
                        Text("End")
                    }
                    .buttonStyle(KeyButton())
                }
                
            }
            .transition(.slideInFromBottom)
            .animation(.none)
        }
    }
}
struct KeyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 75, height: 75)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
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
}




// Saving for later
//                Button("Submit"){
//                    if answer == String(currentInfo.answer){
//                        sessionScore += 1
//                        currentInfo = equationShuffle(termCount: Int(sliderValue))
//                        answer = ""
//                    } else {
//                        withAnimation(.default){
//                            attempts += 1
//                            answer = ""
//                        }
//                    }
//                }
