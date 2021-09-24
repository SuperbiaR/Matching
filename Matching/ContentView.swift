import SwiftUI

struct Home: View {
    @State var moves: [String] = Array(repeating: "", count: 20)
    @State var isPlaying = false
    @State var gameOver = false
    @State var msg = ""
    @State public var ArrayList:[String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    @State public var flipChances: Int = 0
    @State public var played: [Int] = []
    @State public var matches = 0
    
    var body: some View {
        VStack {
            VStack{}.onAppear(perform: { ArrayList.shuffle() })
            // creates the GridView
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(0..<20, id: \.self) { index in
                    ZStack {
                        Color.green
                        Color.white
                            .opacity(moves[index] == "" ? 0 : 1)
                        
                        Text(moves[index])
                            .font(.system(size: 65))
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 360 : 0),
                        axis: (x: 0.0, y: 2.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)) {
                            
                            if moves[index] == "" {
                                moves[index] = ArrayList[index]
                                flipChances = flipChances + 1
                                played.append(index)
                                
                                if(flipChances == 2) {
                                    flipChances = 0
                                    if (moves[played[0]] == moves[played[1]]) {
//                                        print("Yee")
                                        played.removeAll()
                                        flipChances = 0
                                        matches += 1
                                        if (matches == 10) { gameOver = true }
                                    } else {
//                                        print("NA")
                                        moves[played[0]] = ""
                                        moves[played[1]] = ""
                                        played.removeAll()
                                        flipChances = 0
                                    }
                                    
                                }
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text("gg"), dismissButton: .destructive(Text("Bye Bye"),action: {
                fatalError()
            }))
        })
    }
    
    // calculates width of squares
    func getWidth() -> CGFloat {
        let width = UIScreen.main.bounds.width - (30 + 30)
        return width / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .navigationTitle("Tic Tac Toe")
            .preferredColorScheme(.dark)
    }
}

