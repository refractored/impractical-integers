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
    @State var shouldAnimateCheckmark = false
    @State var timeRemaining = 60
    @State var sessionScore = 0
    @State var sliderValue: Float = 2.0
    @State var attempts: Int = 0
    @State var equations = false
    @State var answer = ""
    @State var timer = -1
    @State var currentInfo = equationInfo(terms: [Int](), answer: 0, displayText: "")
    @AppStorage("correct") private var timedHighScore = -1
    @Environment(\.presentationMode) var presentationMode
    let buttonBackground = Color("buttonBackground")
    let endSoundEffect: SystemSoundID = 1112
    let startSoundEffect: SystemSoundID = 1110

    private func endGame(animated: Bool){
        answer = ""
        AudioServicesPlaySystemSound(endSoundEffect)
        if animated{
            withAnimation(.none) {
                equations = false
            }
        }else{
            equations = false
        }
        if sessionScore > timedHighScore {
            timedHighScore = sessionScore
        }
    }
    
    private func startGame(){
        answer = ""
        AudioServicesPlaySystemSound(startSoundEffect)
        equations = true
        sessionScore = 0
        currentInfo = equationShuffle(termCount: Int(sliderValue))
        timeRemaining = 60
    }
    
    var body: some View {
        VStack {
            if !equations{
                MenuScreen(
                    sliderValue: $sliderValue,
                    timedHighScore: $timedHighScore,
                    startGame: {
                      self.startGame()
                  })
            }else{
                GameScreen(
                    shouldAnimateCheckmark: $shouldAnimateCheckmark,
                    timeRemaining: $timeRemaining,
                       timedHighScore: $timedHighScore,
                       answer: $answer,
                       attempts: $attempts,
                       sessionScore: $sessionScore,
                       sliderValue: $sliderValue,
                       currentInfo: $currentInfo,
                       endGame: {
                           self.endGame(animated: true)
                       })
                Spacer()
                    .frame(maxHeight: 30)
                Keypad(answer: $answer,
                       attempts: $attempts,
                       endGame: {
                      self.endGame(animated: true)
                  })
            }
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
private struct GameScreen: View{
    @Binding var shouldAnimateCheckmark: Bool
    @Binding var timeRemaining: Int
    @Binding var timedHighScore: Int
    @Binding var answer: String
    @Binding var attempts: Int
    @Binding var sessionScore: Int
    @Binding var sliderValue: Float
    @Binding var currentInfo: equationInfo
    private let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var endGame: () -> Void
    let buttonBackground = Color("buttonBackground")
    @Environment(\.presentationMode) var presentationMode
    let systemSoundID: SystemSoundID = 1407
    
    var body: some View{
        VStack{
            Image(systemName: "clock.fill")
                .imageScale(.large)
                .foregroundColor(buttonBackground)
            Text(String(timeRemaining))
                .font(.largeTitle)
                .fontWeight(.heavy)
                .onReceive(countdown) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        self.endGame()
                    }
                }
            
            AnimatedCheckmarkView(isAnimating: $shouldAnimateCheckmark)
            Text(currentInfo.displayText)
            TextField("Answer", text: $answer)
                .font(.headline)
                .fontWeight(.heavy)
                .modifier(jiggleEffect(animatableData: CGFloat(attempts)))
                .multilineTextAlignment(.center)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
                .onChange(of: answer) { newValue in
                    if let userAnswer = Int(newValue),
                       userAnswer == currentInfo.answer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            AudioServicesPlaySystemSound(systemSoundID)
                            shouldAnimateCheckmark = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                shouldAnimateCheckmark = false
                            }
                            print(shouldAnimateCheckmark)
                            sessionScore += 1
                            currentInfo = equationShuffle(termCount: Int(sliderValue))
                            answer = ""
                        }
                    }
                }
        }
        .transition(.slideInFromBottom)
        .animation(.spring())
    }
}
private struct MenuScreen: View{
    @Binding var sliderValue: Float
    @Binding var timedHighScore: Int
    var startGame: () -> Void
    let buttonBackground = Color("buttonBackground")
    @Environment(\.presentationMode) var presentationMode
    let buttonForeground = Color("buttonForeground")

    var body: some View{
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
//
        Button(action:{
            self.startGame()
        }) {
            HStack {
                Image(systemName: "play.circle")
                   .font(.title3)
                Text("Start")
                    .font(.title3)
            }
            .frame(maxWidth: 320, maxHeight: 30)

        }
        .foregroundColor(buttonForeground)
        .buttonStyle(.borderedProminent)
        .tint(buttonBackground)
        .foregroundColor(.white)
        .buttonStyle(.borderedProminent)
        .tint(buttonBackground)
        Button(action:{
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "gobackward")
                   .font(.title3)
                Text("Back")
                    .font(.title3)
            }
            .frame(maxWidth: 320, maxHeight: 30)

        }
        .foregroundColor(buttonForeground)
        .buttonStyle(.borderedProminent)
        .tint(buttonBackground)
        .foregroundColor(.white)
        .buttonStyle(.borderedProminent)
        .tint(buttonBackground)
        
    }
}
struct Keypad: View{
    @Binding var answer: String
    @Binding var attempts: Int
    let systemSoundID: SystemSoundID = 1306


    var endGame: () -> Void
    
    var body: some View{
            VStack {
                HStack {
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)
                        answer += "1"
                    }) {
                        Text("1")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "2"
                    }) {
                        Text("2")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "3"
                    }) {
                        Text("3")
                    }
                    .buttonStyle(KeyButton())
                }
                HStack {
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "4"
                    }) {
                        Text("4")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "5"
                    }) {
                        Text("5")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "6"
                    }) {
                        Text("6")
                    }
                    .buttonStyle(KeyButton())
                }
                HStack {
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "7"

                    }) {
                        Text("7")
                    }
                    .buttonStyle(KeyButton())
                    
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)

                        answer += "8"
                    }) {
                        Text("8")
                    }
                    .buttonStyle(KeyButton())
                    Button(action: {
                        AudioServicesPlaySystemSound(systemSoundID)
                        answer += "9"
                    }) {
                        Text("9")
                    }
                    .buttonStyle(KeyButton())
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
                        withAnimation(.default){
                            attempts += 1
                            answer = ""
                        }
                        
                    }) {
                        Text("C")
                    }
                    .buttonStyle(KeyButton())

                }
                HStack {
                    Button("End"){
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
            }
            .transition(.slideInFromBottom)
            .animation(.none)
    
    }
}


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
