import SwiftUI
import Firebase

struct Score: Identifiable {
    let id = UUID()
    let playerName: String
    let score: Int
}

class ScoreViewModel: ObservableObject {
    @Published var scores: [Score] = []
    
    let ref = Database.database().reference()
    
    func addScore(playerName: String, score: Int) {
        let scoreDict: [String: Any] = ["playerName":playerName,"score":score]
        
        ref.child("scores").childByAutoId().setValue(scoreDict)
    }
    
    func listenForScores() {
        ref.child("scores").queryOrdered(byChild: "score").queryLimited(toLast: 10).observe(.value) { snapshot in
            var newScores: [Score] = []

            for child in snapshot.children.reversed() {
                if let snapshot = child as? DataSnapshot,
                   let scoreDict = snapshot.value as? [String: Any],
                   let playerName = scoreDict["playerName"] as? String,
                   let score = scoreDict["score"] as? Int {
                    
                    let score = Score(playerName: playerName, score: score)
                    newScores.append(score)
                }
            }

            self.scores = newScores
        }
    }

}

struct ScoreboardView: View {
    @StateObject var viewModel = ScoreViewModel()
    @State var playerName: String = ""
    @AppStorage("correct") private var timedHighScore = -1
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Image(systemName: "list.number")
                .imageScale(.large)
                .foregroundColor(.red)
            Text("The Scoreboard!")
            Divider()
                .frame(width: 200)

            TextField("Player Name", text: $playerName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 125)
                .multilineTextAlignment(.center)
            Button("Submit") {
                if timedHighScore != -1 && playerName != "" {
                    viewModel.addScore(playerName: playerName, score: timedHighScore)
                    playerName = ""
                }
                
            }
            .foregroundColor(.white)
            .buttonStyle(.borderedProminent)
            .tint(.red)
            Button("Back"){
                presentationMode.wrappedValue.dismiss()
            }
            .accentColor(.red)
            List(viewModel.scores) { score in
                HStack {
                    Text(score.playerName)
                    Spacer()
                    Text("\(score.score)")
                }
            }
        }
        .onAppear {
            viewModel.listenForScores()
        }
    }
}

