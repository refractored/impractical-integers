//
//  ContentView.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct HomeScreen: View {
    @State var timedNavigate = false
    @State var infiniteNavigate = false
    @State var leaderboardNavigate = false
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundColor(.red)
            Text("Hello Algebra!")
            Divider()
                .frame(width: 200)
            Button("60 Seconds") {
                timedNavigate = true
            }
            
            
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            
            Button("Infinite") {
                infiniteNavigate = true
            }
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            Button("Leaderboard") {
                leaderboardNavigate = true
            }
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .navigate(to: TimedEquations(), when: $timedNavigate)
        .navigate(to: InfiniteEquations(), when: $infiniteNavigate)
        .navigate(to: ScoreboardView(), when: $leaderboardNavigate)

        .analyticsScreen(name: "\(HomeScreen.self)")


    }
}
extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden((true))
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
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
