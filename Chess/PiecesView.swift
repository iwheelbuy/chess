//
//  PiecesView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PiecesView: View {

   let namespace: Namespace.ID?
   var pieces: [Position: Piece]
   var taken: [Position: Piece] = [:]

   var body: some View {
      ZStack(alignment: .center, content: {
         HStack(alignment: .center, spacing: 0, content: {
            ForEach(0 ... 7, id: \.self, content: { x in
               VStack(alignment: .center, spacing: 0, content: {
                  ForEach(0 ... 7, id: \.self, content: { y in
                     let position = Position(x: x, y: y)
                     if let piece = taken[position] {
                        PieceView(namespace: namespace, piece: piece)
                           .opacity(0.5)
//                           .transition(.plain)
                     } else {
                        SwiftUI.Color.clear
//                           .transition(.plain)
                     }
                  })
               })
            })
         })
         HStack(alignment: .center, spacing: 0, content: {
            ForEach(0 ... 7, id: \.self, content: { x in
               VStack(alignment: .center, spacing: 0, content: {
                  ForEach(0 ... 7, id: \.self, content: { y in
                     let position = Position(x: x, y: y)
                     if let piece = pieces[position] {
                        PieceView(namespace: namespace, piece: piece)
//                           .transition(.plain)
                     } else {
                        SwiftUI.Color.clear
//                           .transition(.plain)
                     }
                  })
               })
            })
         })
      })
      .aspectRatio(1, contentMode: .fit)
   }
}

extension AnyTransition {

   static var plain: AnyTransition {
      AnyTransition.modifier(
         active: PlainTransitionModifier(),
         identity: PlainTransitionModifier()
      )
   }
}

struct PlainTransitionModifier: ViewModifier {

   func body(content: Content) -> some View {
      content
   }
}

struct PiecesView_Previews: PreviewProvider {

   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         PiecesView(
            namespace: nil,
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
