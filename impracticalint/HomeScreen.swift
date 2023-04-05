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

func equationShuffle(equationCount: Int) -> equationInfo{
        var temp = equationInfo(terms: [Int](), answer: 0, displayText: "")
    
        while temp.terms.count < equationCount{
            temp.terms.append(Int.random(in: -20 ... 20))
        }
    for i in 0..<equationCount {
        let randomNumber = Int.random(in: 0...1)
        let term = temp.terms[i]
        if randomNumber == 1 {
            if !temp.displayText.isEmpty {
                temp.answer += term
                temp.displayText += " + \(term)"
            } else {
                temp.answer = term
                temp.displayText += "\(term)"
            }
        } else {
            if !temp.displayText.isEmpty {
                temp.answer -= term
                temp.displayText += " - \(term)"
            } else {
                temp.answer = term
                temp.displayText += "\(term)"
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
