import SwiftUI

struct ContentView: View {
    @State private var showPlayerInput: Bool = false // Track if player input should be shown
    @State private var playerCount: String = ""
    @State private var players: [String] = []
    @State private var playerScores: [Int] = [] // Array to hold player scores
    @State private var previousScores: [[Int]] = [] // Array to hold previous scores for undo functionality
    @State private var expandedPlayerIndex: Int? // Track which player button is expanded
    @State private var showMainMenu: Bool = true // Track if main menu should be shown
    @State private var customScore: String = "" // New state variable to hold the custom score input

    var body: some View {
        VStack {
            // Show exit button to return to main menu
            if !showMainMenu {
                Button(action: {
                    // Action to return to main menu
                    showMainMenu = true
                    showPlayerInput = false
                    playerCount = ""
                    players.removeAll()
                    playerScores.removeAll()
                    previousScores.removeAll() // Clear previous scores
                }) {
                    Text("X")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            // Show main menu buttons if in main menu
            if showMainMenu {
                // Button for Ticket to Ride
                Button(action: {
                    // Action for Ticket to Ride
                    showPlayerInput = true // Show player input when button is clicked
                    showMainMenu = false // Hide main menu buttons
                }) {
                    Text("Ticket to Ride")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            
            // Show player input if the Ticket to Ride button was clicked
            if showPlayerInput {
                VStack {
                    // Input for number of players
                    TextField("Enter number of players", text: $playerCount)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                    
                    // Button to confirm player count
                    Button(action: {
                        if let count = Int(playerCount), count > 0 && count <= 7 { // Limit player count to 7
                            players = Array(repeating: "Player \(players.count + 1)", count: count)
                            playerScores = Array(repeating: 0, count: count) // Initialize scores to 0
                            previousScores = Array(repeating: [0], count: count) // Initialize previous scores for undo
                            showPlayerInput = false // Hide player input after setting count
                        }
                    }) {
                        Text("Set Player Count")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
            
            // Display players and their scores if player count is set
            if !players.isEmpty {
                VStack {
                    ForEach(players.indices, id: \.self) { index in
                        VStack {
                            Button(action: {
                                // Toggle expanded state for the player button
                                expandedPlayerIndex = (expandedPlayerIndex == index) ? nil : index
                            }) {
                                HStack {
                                    Text(players[index])
                                    Spacer()
                                    Text("Score: \(playerScores[index])") // Display score
                                }
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                            }
                            
                            // Show scoring buttons if the player button is expanded
                            if expandedPlayerIndex == index {
                                VStack {
                                    HStack {
                                        Button(action: {
                                            addScore(for: index, points: 1)
                                        }) {
                                            Text("1 Train")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                        
                                        Button(action: {
                                            addScore(for: index, points: 2)
                                        }) {
                                            Text("2 Trains")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            addScore(for: index, points: 4)
                                        }) {
                                            Text("3 Trains")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                        
                                        Button(action: {
                                            addScore(for: index, points: 7)
                                        }) {
                                            Text("4 Trains")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                    }
                                    
                                    HStack {
                                        Button(action: {
                                            addScore(for: index, points: 15)
                                        }) {
                                            Text("6 Trains")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                        
                                        Button(action: {
                                            addScore(for: index, points: 21)
                                        }) {
                                            Text("7 Trains")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(5)
                                        }
                                    }
                                    
                                    // Calculator input for custom score
                                    HStack {
                                        TextField("Enter score", text: $customScore)
                                            .keyboardType(.numberPad)
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                        
                                        Button(action: {
                                            if let scoreToAdd = Int(customScore) { // Convert customScore to Int
                                                addScore(for: index, points: scoreToAdd)
                                                customScore = "" // Clear the input after adding
                                            }
                                        }) {
                                            Text("Add Score")
                                                .padding()
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                    }
                                    
                                    // Undo button
                                    Button(action: {
                                        undoScore(for: index)
                                    }) {
                                        Text("Undo")
                                            .padding()
                                            .background(Color.yellow.opacity(0.5))
                                            .cornerRadius(5)
                                    }
                                    .padding(.top, 5)
                                    
                                    // Reset Score button
                                    Button(action: {
                                        resetScore(for: index)
                                    }) {
                                        Text("Reset Score")
                                            .padding()
                                            .background(Color.red.opacity(0.5))
                                            .cornerRadius(5)
                                    }
                                    .padding(.top, 5)
                                    
                                    // Show option to change name if the player button is expanded
                                    TextField("Change name", text: Binding(
                                        get: { players[index] },
                                        set: { players[index] = $0 }
                                    ))
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                    .padding(.top, 5)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .padding()
            }
        }
        .padding()
    }
    
    // Function to add score and keep track of previous scores
    private func addScore(for index: Int, points: Int) {
        previousScores[index].append(playerScores[index]) // Store previous score for undo
        playerScores[index] += points
    }
    
    // Function to undo the last score change
    private func undoScore(for index: Int) {
        guard previousScores[index].count > 1 else { return } // Ensure there's a previous score to revert to
        playerScores[index] = previousScores[index].removeLast() // Revert to the last score
    }
    
    // Function to reset the player's score to 0
    private func resetScore(for index: Int) {
        previousScores[index].append(playerScores[index]) // Store current score for undo
        playerScores[index] = 0 // Reset score
    }
}

#Preview {
    ContentView()
}
