//
//  ContentView.swift
//  Chess
//
//  Created by iwheelbuy on 03.07.2022.
//

import SwiftUI

struct ContentView: View {

   @ObservedObject private var viewModel = ContentViewModel()

   init() {
   }
   
   var body: some View {
      VStack(alignment: .center, spacing: 0, content: {
         Spacer()
         HStack(alignment: .center, spacing: 0, content: {
            ForEach(0 ... 7, id: \.self, content: { x in
               VStack(alignment: .center, spacing: 0, content: {
                  ForEach(0 ... 7, id: \.self, content: { y in
                     let position = Position(x: x, y: y)
                     squareView(position: position)
                  })
               })
            })
         })
         .aspectRatio(1, contentMode: .fit)
         Spacer()
      })
      .background(SwiftUI.Color.cyan)
   }

   @ViewBuilder
   func squareView(position: Position) -> some View {
      let background: SwiftUI.Color = {
         if viewModel.selected == position {
            return SwiftUI.Color.green
         } else {
            let white = (position.x + position.y) % 2 == 0
            return white ? SwiftUI.Color.yellow : SwiftUI.Color.brown
         }
      }()
      ZStack(alignment: .center) {
         background
         pieceView(position: position)
      }.onTapGesture(count: 1) { [weak viewModel] in
         viewModel?.select(position: position)
      }
   }

   @ViewBuilder
   func pieceView(position: Position) -> some View {
      if let piece = viewModel.game.board.piece(at: position) {
         VStack(alignment: .center, spacing: 0) {
            Spacer()
            SwiftUI.Image(piece.type.rawValue)
               .resizable()
               .foregroundColor(piece.color == .white ? .white : .black)
               .scaledToFit()
            Spacer()
         }
      } else {
         Spacer()
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      ContentView()
   }
}
