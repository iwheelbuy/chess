//
//  PiecesView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct Object: Hashable {

   let piece: Piece
   let position: Position
}

struct PiecesView: View {

   let namespace: Namespace.ID?
   var pieces: [Position: Piece]

   var body: some View {
      GeometryReader { metrics in
         ForEach(objects(), id: \.self, content: { boardObject in
            PieceView(namespace: namespace, piece: boardObject.piece)
               .position(position(metrics: metrics, position: boardObject.position))
               .frame(width: side(metrics: metrics), height: side(metrics: metrics))
         })
      }
   }

   private func objects() -> [Object] {
      return pieces
         .map({ (position, piece) in
            Object(piece: piece, position: position)
         })
   }

   private func side(metrics: GeometryProxy) -> CGFloat {
      return min(metrics.size.width, metrics.size.height) / 8
   }

   private func position(metrics: GeometryProxy, position: Position) -> CGPoint {
      let centerX = metrics.size.width / 2
      let centerY = metrics.size.height / 2
      let x = (CGFloat(position.x - 4) + 0.5) * side(metrics: metrics) + centerX
      let y = (CGFloat(position.y - 4) + 0.5) * side(metrics: metrics) + centerY
      return CGPoint(x: x, y: y)
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
