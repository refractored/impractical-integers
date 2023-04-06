//
//  ContentView.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct equationInfo{
    var terms: [Int]
    var answer: Int
    var displayText: String
}

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

struct milkshoke: GeometryEffect{
    var amount: CGFloat = 10
    var shakesperunit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesperunit)), y: 0))
    }
}

func equationShuffle(termCount: Int) -> equationInfo{
    var temp = equationInfo(terms: [Int](), answer: 0, displayText: "")
    
    // Generate terms with given number from paramaters (termCount).
    while temp.terms.count < termCount{
        temp.terms.append(Int.random(in: -20 ... 20))
    }
    
    for i in 0..<termCount {
        let isAddition = Bool.random()
        let term = temp.terms[i]
        
        // Check if this is the first term, if so, make it equal to answer
        // Without this check in place, Subtracting a negative number for the first term from 0, will make it positive. Ex: f(-3) = 0 - (-3) = 3
        
        if temp.displayText.isEmpty{
            temp.answer = term
            temp.displayText += "\(term)"
        }
        
        // If else, run operations required to get the new answer.
        if !temp.displayText.isEmpty{
            if isAddition{
                temp.answer += term
                temp.displayText += " + \(term)"
            }else{
                temp.answer -= term
                temp.displayText += " - \(term)"
            }
        }
        

    }
        print("\(temp.answer)")
        return temp
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
