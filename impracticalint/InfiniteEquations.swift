//
//  InfiniteEquations.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI


struct InfiniteEquations: View {
    @State var timeRemaining = 10
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @AppStorage("infCorrectScore") private var infCorrectScore = 0
    @AppStorage("infIncorrectScore") private var infIncorrectScore = 0
    @State var ratioScore: Double = 0.0
    @State var sliderValue: Float = 2.0
    @State var attempts: Int = 0
    @State var equations = false
    @State var timedNavigate = false
    @State var answer = ""
    @State var converted = ""
    @State var timer = -1
    @State var text = "Begin"
    @State var currentInfo = equationInfo(thingys: [Int](), answer: 0, displayText: "")
    var body: some View {
        
        VStack {
            
            Image(systemName: "infinity.circle.fill")
                .imageScale(.large)
                .foregroundColor(.red)
            Text("Infinity!")
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
                
                //if infCorrectScore != -1{
                    Text("C/I Ratio:")
                    Text("\(converted)").font(.title2).fontWeight(.thin)
                    .onAppear(perform: {
                         converted = String(format: "%.1f", (Double(infCorrectScore) / Double(infIncorrectScore)))
                    })
                //}
            }
            if equations {
                Text(String(timeRemaining))
                    .font(.largeTitle)
                    .onReceive(countdown){ time in
                        if timeRemaining > 0 {
                            
                            timeRemaining -= 1
                        }else{
                            infIncorrectScore += 1
                            timeRemaining = 10
                            print("\(infCorrectScore) / \(infIncorrectScore)")
                            ratioScore = Double(infCorrectScore) / Double(infIncorrectScore)
                            equationShuffle(equationCount: Int(sliderValue), equations: &equations, equationInfos: &currentInfo)
                            
                            
                            
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
                        infCorrectScore += 1
                        equationShuffle(equationCount: Int(sliderValue), equations: &equations, equationInfos: &currentInfo)
                        answer = ""
                    } else {
                        infIncorrectScore += 1
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
                    equationShuffle(equationCount: Int(sliderValue), equations: &equations, equationInfos: &currentInfo)
                    timeRemaining = 10
                    
                }
            }
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
//            if !equations{
//                Button("Back"){
//                    timedNavigate = true
//                }
//                .accentColor(.red)
//                
//            }
            
            
        }
        //            Text("TBA")
        //                .font(.largeTitle)
        //            Text("Correct/Incorrect Ratio")
        //                .font(.footnote)
        .navigate(to: HomeScreen(), when: $timedNavigate)
    }
    
}



struct InfiniteEquations_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteEquations()
    }
}
