//
//  PiecesView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PiecesView: View {

   let namespace: Namespace.ID
   var pieces: [Position: Piece]

   private var objects: [Object] {
      return pieces
         .map({ (position, piece) in
            Object(piece: piece, position: position)
         })
   }

   var body: some View {
      GeometryReader { geometry in
         ForEach(objects, id: \.self, content: { object in
            let side = min(geometry.size.width, geometry.size.height) / 8
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            let x = (CGFloat(object.position.x - 4) + 0.5) * side + centerX
            let y = (CGFloat(object.position.y - 4) + 0.5) * side + centerY
            let position = CGPoint(x: x, y: y)
            PieceView(namespace: namespace, piece: object.piece)
               .position(position)
               .frame(width: side, height: side)
         })
      }
      .allowsHitTesting(false)
   }
}

extension PiecesView {

   private struct Object: Hashable {

      let piece: Piece
      let position: Position
   }
}

struct PlainTransitionModifier: ViewModifier {

   func body(content: Content) -> some View {
      content
   }
}

struct PiecesView_Previews: PreviewProvider {

   @Namespace
   static var namespace

   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         PiecesView(
            namespace: namespace,
            pieces: [
               .init(x: 0, y: 0): .init(color: .black, type: .rook),
               .init(x: 2, y: 5): .init(color: .white, type: .knight),
               .init(x: 0, y: 7): .init(color: .white, type: .king),
               .init(x: 3, y: 3): .init(color: .black, type: .bishop),
               .init(x: 7, y: 7): .init(color: .white, type: .queen),
               .init(x: 7, y: 0): .init(color: .black, type: .pawn)
            ]
         )
         .background(.orange)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .frame(width: 175, height: 225)
      .foregroundColor(.cyan)
   }
}
