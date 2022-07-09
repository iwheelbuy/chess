//
//  PiecesView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PiecesView: View {

   let current: Namespace.ID?
   let taken: Namespace.ID?
   var pieces: [Position: Piece]
   var piecesTaken: [Position: Piece] = [:]

   var body: some View {
      HStack(alignment: .center, spacing: 0, content: {
         ForEach(0 ... 7, id: \.self, content: { x in
            VStack(alignment: .center, spacing: 0, content: {
               ForEach(0 ... 7, id: \.self, content: { y in
                  let position = Position(x: x, y: y)
                  if let piece = pieces[position] {
                     PieceView(namespace: current, piece: piece)
                        .zIndex(1)
                        .transition(.scale(scale: 1))
                  } else if let piece = piecesTaken[position] {
                     PieceView(namespace: taken, piece: piece)
                        .opacity(0.5)
                        .zIndex(0)
                        .transition(.scale(scale: 2))
                  } else {
                     SwiftUI.Color.clear
                  }
               })
            })
         })
      })
      .aspectRatio(1, contentMode: .fit)
   }
}

struct PiecesView_Previews: PreviewProvider {

   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         PiecesView(
            current: nil,
            taken: nil,
            pieces: [
               .init(x: 2, y: 3): .init(color: .white, type: .rook),
               .init(x: 4, y: 6): .init(color: .black, type: .bishop)
            ]
         )
         .background(.orange)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .frame(width: 150, height: 200)
      .foregroundColor(.cyan)
   }
}
