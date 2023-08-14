//
//  TimedEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import AVFoundation
import PopupView

class TimedEquationsViewModel: ObservableObject {
    @Published var shouldAnimateCheckmark = false
    @Published var timeRemaining = 60
    @Published var sessionScore = 0
    @Published var sliderValue: Float = 2.0
    @Published var attempts: Int = 0
    @Published var leaderboardNavigate = false
    @Published var equations = false
    @Published var answer = ""
    @Published var timer = -1
    @Published var currentInfo = equationInfo(terms: [Int](), answer: 0, displayText: "")
    @Published var popupPresented = false
    @AppStorage("easyHighScore") var easyHighScore = -1
    @AppStorage("normalHighScore") var normalHighScore = -1
    @AppStorage("hardHighScore") var hardHighScore = -1

    private let endSoundEffect: SystemSoundID = 1112
    private let startSoundEffect: SystemSoundID = 1110

    func endGame(animated: Bool) {
        answer = ""
        AudioServicesPlaySystemSound(endSoundEffect)
        if animated {
            withAnimation(.none) {
                equations = false
            }
        } else {
            equations = false
        }

        if sliderValue == 2.0 {
            if sessionScore > easyHighScore {
                easyHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
        }
        if sliderValue == 3.0 {
            if sessionScore > normalHighScore {
                normalHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
        }
        if sliderValue == 4.0 {
            if sessionScore > hardHighScore {
                hardHighScore = sessionScore
                sessionScore = 0
                popupPresented = true
            }
        }
    }

    func startGame() {
        answer = ""
        AudioServicesPlaySystemSound(startSoundEffect)
        equations = true
        sessionScore = 0
        currentInfo = equationShuffle(termCount: Int(sliderValue))
        timeRemaining = 60
    }

}

struct TimedEquations: View {
    @StateObject private var viewModel = TimedEquationsViewModel()

    var body: some View {
        ZStack {
            Image("wateriscool")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if !viewModel.equations {
                    MenuScreen(
                        sliderValue: $viewModel.sliderValue,
                        timedHighScore: $viewModel.easyHighScore,
                        startGame: viewModel.startGame
                    )
                } else {
                    GameScreen()
                    Spacer().frame(maxHeight: 30)
                    Keypad(answer: $viewModel.answer, attempts: viewModel.attempts, endGame:{
                        viewModel.endGame(animated: true)
                    })
                }
            }
        }
        .popup(isPresented: $viewModel.popupPresented) {
            HighScorePopup(popupPresented: $viewModel.popupPresented, leaderboardNavigate: $viewModel.leaderboardNavigate)
        } customize: { popup in
            popup.type(.toast)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.black.opacity(0.5))
        }
        .navigate(to: ScoreboardView(), when: $viewModel.leaderboardNavigate)
    }
}


private struct GameScreen: View{
    @StateObject private var viewModel = TimedEquationsViewModel()
    private let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let buttonBackground = Color("buttonBackground")
    @Environment(\.presentationMode) var presentationMode
    let systemSoundID: SystemSoundID = 1407
    
    var body: some View{
        ZStack{

        VStack{
            Image(systemName: "clock.fill")
                .imageScale(.large)
                .foregroundColor(buttonBackground)
            Text(String(viewModel.timeRemaining))
                .font(.largeTitle)
                .fontWeight(.heavy)
                .onReceive(countdown) { _ in
                    if viewModel.timeRemaining > 0 {
                        viewModel.timeRemaining -= 1
                    } else {
                        viewModel.endGame(animated: true)
                    }
                }
            
            AnimatedCheckmarkView(isAnimating: $viewModel.shouldAnimateCheckmark)
            Text(viewModel.currentInfo.displayText)
            TextField("Answer", text: $viewModel.answer)
                .frame(width: 180	)
                .font(.headline)
                .fontWeight(.heavy)
                .modifier(jiggleEffect(animatableData: CGFloat(viewModel.attempts)))
                .multilineTextAlignment(.center)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
                .onChange(of: viewModel.answer) { newValue in
                    if let userAnswer = Int(newValue),
                       userAnswer == viewModel.currentInfo.answer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            AudioServicesPlaySystemSound(systemSoundID)
                            viewModel.shouldAnimateCheckmark = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                viewModel.shouldAnimateCheckmark = false
                            }
                            viewModel.sessionScore += 1
                            viewModel.currentInfo = equationShuffle(termCount: Int(viewModel.sliderValue))
                            viewModel.answer = ""
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
