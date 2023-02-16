//
//  ContentView.swift
//  impracticalint
//
//  Created by David M. Galvan on 2/16/23.
//

import SwiftUI

struct HomeScreen: View {
    @State var timedNavigate = false
    @State var infiniteNavigate = false
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
        }
        .navigate(to: TimedEquations(), when: $timedNavigate)
        .navigate(to: InfiniteEquations(), when: $infiniteNavigate)
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
                    .navigationBarHidden(true)
                
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
