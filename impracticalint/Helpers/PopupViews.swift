//
//  PopupViews.swift
//  impracticalint
//
//  Created by David G on 8/11/23.
//

import SwiftUI

struct HighScorePopup: View {
    @Binding var popupPresented: Bool
    @Binding var leaderboardNavigate: Bool
    var body: some View {
        ZStack{
            Spacer()
                .frame(height: 325)
                .background(Color("buttonBackground"))
                .cornerRadius(30.0)
            VStack{
                Text("Congratulations!")
                    .fontWeight(.heavy)
                    .font(.title)
                Text("🎉")
                    .font(.system(size: 75))
                Text("You've beat your previous high score!")
                    .fontWeight(.heavy)
                    .font(.system(size: 15))
                Text("Would you like to post this on the leaderboard?")
                    .fontWeight(.heavy)
                    .font(.system(size: 15))
                Button(action:{
                    popupPresented = false
                    leaderboardNavigate = true
                }) {
                    HStack {
                        Image(systemName: "checkmark.icloud.fill")
                           .font(.title3)
                        Text("Yes")
//                            .frame(maxWidth: 200, maxHeight: 30)
//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(Color("buttonForeground"))
                .buttonStyle(.borderedProminent)
                .tint(Color("buttonBackground"))
                
                Button(action:{
                    popupPresented = false
                }) {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                           .font(.title3)
                        Text("No")
//                            .frame(maxWidth: 200, maxHeight: 30)
//                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                    .frame(maxWidth: 320, maxHeight: 30)

                }
                .foregroundColor(Color("buttonForeground"))
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
    }
}
