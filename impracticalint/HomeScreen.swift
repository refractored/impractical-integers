//
//  ContentView.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI

struct equationInfo{
    var terms: [Int]
    var answer: Int
    var displayText: String
}
struct ImageOverlay: View{
    var body: some View {
        HStack{
            Spacer()
                .frame(width: 30)
            VStack{
                Spacer()
                    .frame(height: 30)
                ZStack{
                    VStack{
                        HStack{
                            Text("Impractical Integers")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                            //                            .padding(6)
                                .font(.callout)
                            Spacer()
                        }
                        HStack{
                            Text("Master your math.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            //                            .padding(6)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                                .frame(alignment: .leading)
                                Spacer()
                        }
                    }
                }
//                }.background(Color.black)
//                    .opacity(0.8)
//                    .cornerRadius(10.0)
//                    .padding(6)
            }
        }
    }
}
struct ScoreOverlay: View{
    var body: some View {
        HStack{
            Spacer()
                .frame(width: 60)
            VStack{
                Spacer()
                    .frame(height: 30)
                ZStack{
                    VStack{
                        Text("tes")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .font(.callout)
                        Spacer()
                            .frame(maxHeight: 20)
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
                
                }
//                }.background(Color.black)
//                    .opacity(0.8)
//                    .cornerRadius(10.0)
//                    .padding(6)
            }
        }
    }
}
struct HomeScreen: View {
    @State var timedNavigate = false
    @State var infiniteNavigate = false
    @State var leaderboardNavigate = false
    let buttonBackground = Color("buttonBackground")
    let buttonForeground = Color("buttonForeground")
    var body: some View {
        ZStack{
            Color.pink.ignoresSafeArea()
            VStack {
                Image("math") // Replace `.building` with your image's name

                    .resizable()
                    .cornerRadius(20)
                    .padding()
                    //.scaledToFit()
                    // .scaleEffect(0.5)
                    .frame(width: 400, height: 500)
                    .overlay(
                        ImageOverlay(), alignment: .topLeading
                    )
                    .overlay(
                        ScoreOverlay(), alignment: .bottomLeading
                    )
                //            Image(systemName: "heart.fill")
                //                .imageScale(.large)
                //                .foregroundColor(.red)
                //            Text("Hello Algebra!")
//                Divider()
//                    .frame(width: 200)
                Button(action:{
                    timedNavigate = true
                }) {
                    HStack {
                        Image(systemName: "clock.fill")
                           .font(.title3)
                        Text("Timed")


//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                
                .foregroundColor(buttonForeground)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
                
//                Button("Infinite") {
//                    infiniteNavigate = true
//                }
//                .foregroundColor(.blue)
//                .buttonStyle(.borderedProminent)
//                .tint(buttonBackground)
                
                Button(action:{
                    infiniteNavigate = true
                }) {
                    HStack {
                        Image(systemName: "infinity.circle.fill")
                           .font(.title3)
                        Text("Infinity")
//                            .frame(maxWidth: 200, maxHeight: 30)
//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(buttonForeground)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
//                Button("Leaderboard") {
//                    leaderboardNavigate = true
//                }
//                .foregroundColor(.blue)
//                .buttonStyle(.borderedProminent)
//                .tint(buttonBackground)
                Button(action:{
                    leaderboardNavigate = true
                }) {
                    HStack {
                        Image(systemName: "list.number")
                           .font(.title3)
                        Text("Leaderboard")
//                            .frame(maxWidth: 200, maxHeight: 30)
                        //                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(buttonForeground)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
            }
            .navigate(to: TimedEquations(), when: $timedNavigate)
            .navigate(to: InfiniteEquations(), when: $infiniteNavigate)
            .navigate(to: ScoreboardView(), when: $leaderboardNavigate)
            
        }
        .accentColor(.black)

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

struct jiggleEffect: GeometryEffect{
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
        
        // Looks less confusing with bigger equations.
        let displayterm = term < 0 ? "(\(term))" : "\(term)"
        
        // Run operations required to get the new answer if text is not empty.
        if !temp.displayText.isEmpty{
            if isAddition{
                temp.answer += term
                temp.displayText += " + \(displayterm)"
            }else{
                temp.answer -= term
                temp.displayText += " - \(displayterm)"
            }
        }
            
        // Check if this is the first term, if so, make it equal to answer
        // Without this check in place, Subtracting a negative number from the default value 0, will make it positive. Ex: f(-3) = 0 - (-3) = 3
        
        if temp.displayText.isEmpty{
            temp.answer = term
            temp.displayText += "\(displayterm  )"
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
