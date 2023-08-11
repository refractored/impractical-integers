//
//  ContentView.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI

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
            }
        }
    }
}
struct ScoreOverlay: View{
    @AppStorage("correct") private var timedHighScore = -1

    var body: some View {
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .background(.ultraThinMaterial)
                        .frame(width: 150, height: 65)
                        .clipShape(Capsule())
                    VStack{
                        Text("Timed Highest:")
                            .font(.body)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .font(.callout)
                        Text("\(timedHighScore)")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .font(.callout)

                    }

                
                }
                .padding()
                .fixedSize()
                Spacer()
                    .frame(maxHeight: 25)
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
                Image("math")

                    .resizable()
                    .cornerRadius(20)
                    .padding()

                    .frame(width: 400, height: 550)
                    .overlay(
                        ImageOverlay(), alignment: .topLeading
                    )
                    .overlay(
                        ScoreOverlay(), alignment: .bottom
                    )
                Button(action:{
                    timedNavigate = true
                }) {
                    HStack {
                        Image(systemName: "clock.fill")
                           .font(.title3)
                        Text("Timed")
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                
                .foregroundColor(buttonForeground)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
                Button(action:{
                    infiniteNavigate = true
                }) {
                    HStack {
                        Image(systemName: "infinity.circle.fill")
                           .font(.title3)
                        Text("Infinity")
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(buttonForeground)
                .buttonStyle(.borderedProminent)
                .tint(buttonBackground)
                Button(action:{
                    leaderboardNavigate = true
                }) {
                    HStack {
                        Image(systemName: "list.number")
                           .font(.title3)
                        Text("Leaderboard")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

struct TimedEquations_Previews: PreviewProvider {
    static var previews: some View {
        TimedEquations()
    }
}
