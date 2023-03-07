//
//  TimedEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI

struct milkshoke: GeometryEffect{
    var amount: CGFloat = 10
    var shakesperunit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesperunit)), y: 0))
    }
}


struct equationInfo{
    var thingys: [Int]
    var answer: Int
    var displayText: String
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
    @State var currentInfo = equationInfo(thingys: [Int](), answer: 0, displayText: "")
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
                            equationToggle(equations: &equations, text: &text, equationInfos: &currentInfo)
                            if sessionScore > timedHighScore{
                                timedHighScore = sessionScore
                            }
                        }
                    }
                Text(currentInfo.displayText)
                TextField("Answer", text: $answer)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 125)
                    .modifier(milkshoke(animatableData: CGFloat(attempts)))
                    .multilineTextAlignment(.center)
                Button("Submit"){
                    if answer == String(currentInfo.answer){
                        sessionScore += 1
                        equationShuffle(equationCount: Int(sliderValue), equations: &equations, equationInfos: &currentInfo)
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
                equationToggle(equations: &equations, text: &text, equationInfos: &currentInfo)
                
                if equations{
                    sessionScore = 0
                    equationShuffle(equationCount: Int(sliderValue), equations: &equations, equationInfos: &currentInfo)
                    timeRemaining = 60
                } else {
                    if sessionScore > timedHighScore{
                        timedHighScore = sessionScore
                    }
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
            
            
            }
            //            Text("TBA")
            //                .font(.largeTitle)
            //            Text("Correct/Incorrect Ratio")
            //                .font(.footnote)

        }
        
    }
        
        
    

func equationToggle(equations: inout Bool, text: inout String, equationInfos: inout equationInfo){
    if equations{
        equations = false
        text = "Begin"
    } else {
        equations = true
        text = "End"
    }
}

func equationShuffle(equationCount: Int, equations: inout Bool, equationInfos: inout equationInfo){
    
    
    if equations{
        equationInfos.thingys = []
        equationInfos.displayText = ""
        equationInfos.answer = 0
        
        while equationInfos.thingys.count < equationCount{
            equationInfos.thingys.append(Int.random(in: -20 ... 20))
        }
        print(equationInfos.thingys)
        for i in 0..<equationCount{
            if Int.random(in: 0 ... 1) == 1{
                if equationInfos.displayText != ""{
                    equationInfos.answer += equationInfos.thingys[i]
                    equationInfos.displayText += " + \(equationInfos.thingys[i])"
                } else {
                    equationInfos.answer = equationInfos.thingys[i]
                    equationInfos.displayText += "\(equationInfos.thingys[i])"
                }
            }else{
                if equationInfos.displayText != ""{
                    print(equationInfos.answer)
                    equationInfos.answer -= equationInfos.thingys[i]
                    equationInfos.displayText += " - \(equationInfos.thingys[i])"
                } else {
                    print(equationInfos.answer)
                    equationInfos.answer = equationInfos.thingys[i]
                    
                    equationInfos.displayText += "\(equationInfos.thingys[i])"
                }
            }
        }
        print("Final \(equationInfos.answer)")
        
    } else {
        print("Shuffle requested whilst equationToggle is false. Ignoring...")
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


struct TimedEquations_Previews: PreviewProvider {
    static var previews: some View {
        TimedEquations()
    }
}
