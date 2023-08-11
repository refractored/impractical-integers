//
//  Extensions.swift
//  impracticalint
//
//  Created by David G on 8/11/23.
//

import SwiftUI

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


extension AnyTransition {
    static var slideInFromBottom: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: .identity)
    }
    
    static var slideOutToBottom: AnyTransition {
        let removal = AnyTransition.move(edge: .bottom).combined(with: .opacity)
        return .asymmetric(insertion: .identity, removal: removal)
    }
}
