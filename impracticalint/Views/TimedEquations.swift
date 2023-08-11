//
//  TimedEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import AVFoundation
import PopupView



struct TimedEquations: View {
    @State var shouldAnimateCheckmark = false
    @State var timeRemaining = 60
    @State var sessionScore = 0
    @State var sliderValue: Float = 2.0
    @State var attempts: Int = 0
    @State var leaderboardNavigate = false
    @State var equations = false
    @State var answer = ""
    @State var timer = -1
    @State var currentInfo = equationInfo(terms: [Int](), answer: 0, displayText: "")
    @State var popupPresented = false
//    @AppStorage("correct") private var timedHighScore = -1
    @AppStorage("easyHighScore") private var easyHighScore = -1
    @AppStorage("normalHighScore") private var normalHighScore = -1
    @AppStorage("hardHighScore") private var hardHighScore = -1

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
        

        if sliderValue == 2.0{
            if sessionScore > easyHighScore{
                easyHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
        }
        if sliderValue == 3.0{
            if sessionScore > normalHighScore{
                normalHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
        }
        if sliderValue == 4.0{
            if sessionScore > hardHighScore{
                hardHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
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
        ZStack{
            Image("wateriscool") // 1
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if !equations{
                    MenuScreen(
                        sliderValue: $sliderValue,
                        timedHighScore: $easyHighScore,
                        startGame: {
                            self.startGame()
                        })
                }else{
                    GameScreen(
                        shouldAnimateCheckmark: $shouldAnimateCheckmark,
                        timeRemaining: $timeRemaining,
                        timedHighScore: $easyHighScore,
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
        .popup(isPresented: $popupPresented) {
            HighScorePopup(popupPresented: $popupPresented, leaderboardNavigate: $leaderboardNavigate)
        } customize: {
            $0
               // .autohideIn(2)
                .type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
        .navigate(to: ScoreboardView(), when: $leaderboardNavigate)

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
        ZStack{

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
                .frame(width: 180	)
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
                            sessionScore += 1
                            currentInfo = equationShuffle(termCount: Int(sliderValue))
                            answer = ""
                        }
                    }
                }
            Spacer()
                .frame(maxHeight: 20)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        .transition(.slideInFromBottom)
        .animation(.spring())
                   }

    }
}
private struct MenuScreen: View{
    @Binding var sliderValue: Float
    @Binding var timedHighScore: Int
    @AppStorage("easyHighScore") private var easyHighScore = -1
    @AppStorage("normalHighScore") private var normalHighScore = -1
    @AppStorage("hardHighScore") private var hardHighScore = -1

    var startGame: () -> Void
    let buttonBackground = Color("buttonBackground")
    @Environment(\.presentationMode) var presentationMode
    let buttonForeground = Color("buttonForeground")

    var body: some View{
        VStack{
            Image(systemName: "clock.fill")
                .imageScale(.large)
                .foregroundColor(buttonBackground)
            Text("Timed")
                .fontWeight(.heavy)
                .font(.title3)
            Spacer()
                .frame(maxHeight: 30)
            VStack {
                HStack{
                    if easyHighScore != -1{
                        VStack{
                            Text("Easy")
                                .font(.title3)
                            Text("Top Score:")
                                .font(.title3)
                            Text("\(easyHighScore)").font(.title2).fontWeight(.thin)
                                .onAppear(perform: {
                                    print(normalHighScore)
                                })
                        }
                    }
                    if normalHighScore != -1{
                        VStack{
                            Text("Normal")
                                .font(.title3)

                            Text("Top Score:")
                                .font(.title3)
                            Text("\(normalHighScore)").font(.title2).fontWeight(.thin)
                        }
                    }
                    if hardHighScore != -1{
                        VStack{
                            Text("Hard")
                                .font(.title3)

                            Text("Top Score:")
                                .font(.title3)
                            Text("\(hardHighScore)").font(.title2).fontWeight(.thin)
                        }
                    }
                }
                Spacer()
                    .frame(maxHeight: 30)
                HStack{
                    Button(action:{
                        sliderValue = 2.0
                        
                    }) {
                        HStack {
//                            Image(systemName: "1.circle.fill")
//                                .font(.title3)
                            Text("Easy")
                            //                            .frame(maxWidth: 200, maxHeight: 30)
                            //                            .fontWeight(.semibold)
                                .font(.title3)
                        }
                        .frame(maxWidth: 80, maxHeight: 30)
                       // .foregroundColor(buttonForeground)
                       // .foregroundColor(sliderValue ? Color.blue : Color.yellow)
                        
                    }
                    .foregroundColor(buttonForeground)
                    .buttonStyle(.borderedProminent)
                    .tint(sliderValue == 2 ? Color("difficultySelector") : sliderValue != 2 ? Color("buttonBackground") : Color("buttonBackground"))
                    Button(action:{
                        sliderValue = 3.0
                    }) {
                        HStack {
//                            Image(systemName: "1.circle.fill")
//                                .font(.title3)
                            Text("Normal")
                            //                            .frame(maxWidth: 200, maxHeight: 30)
                            //                            .fontWeight(.semibold)
                                .font(.title3)
                        }
                        .frame(maxWidth: 80, maxHeight: 30)
                        
                    }
                    .foregroundColor(buttonForeground)
                    .buttonStyle(.borderedProminent)
                    .tint(sliderValue == 3 ? Color("difficultySelector") : sliderValue != 3 ? Color("buttonBackground") : Color("buttonBackground"))
                    Button(action:{
                        sliderValue = 4.0
                    }) {
                        HStack {
//                            Image(systemName: "1.circle.fill")
//                                .font(.title3)
                            Text("Hard")
                            //                            .frame(maxWidth: 200, maxHeight: 30)
                            //                            .fontWeight(.semibold)
                                .font(.title3)
                        }
                        .frame(maxWidth: 80, maxHeight: 30)
                        
                    }
                    .foregroundColor(buttonForeground)
                    .buttonStyle(.borderedProminent)
                    .tint(sliderValue == 4 ? Color("difficultySelector") : Color("buttonBackground"))
                }
                
            }
            Spacer()
                .frame(maxHeight: 30)
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
        .padding()
        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 25, style: .continuous)
                        )
    }
}

struct Previews_TimedEquations_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
struct HighScorePopup: View {
    @Binding var popupPresented: Bool
    @Binding var leaderboardNavigate: Bool
    var body: some View {
        ZStack{
            Spacer()
                .frame(height: 325)
                .background(Color("buttonBackground"))
                .cornerRadius(30.0)
            VStack{
                Text("Congratulations!")
                    .fontWeight(.heavy)
                    .font(.title)
                Text("🎉")
                    .font(.system(size: 75))
                Text("You've beat your previous high score!")
                    .fontWeight(.heavy)
                    .font(.system(size: 15))
                Text("Would you like to post this on the leaderboard?")
                    .fontWeight(.heavy)
                    .font(.system(size: 15))
                Button(action:{
                    popupPresented = false
                    leaderboardNavigate = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.icloud.fill")
                           .font(.title3)
                        Text("Yes")
//                            .frame(maxWidth: 200, maxHeight: 30)
//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(Color("buttonForeground"))
                .buttonStyle(.borderedProminent)
                .tint(Color("buttonBackground"))
                
                Button(action:{
                    popupPresented = false
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                           .font(.title3)
                        Text("No")
//                            .frame(maxWidth: 200, maxHeight: 30)
//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(Color("buttonForeground"))
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
    }
}
