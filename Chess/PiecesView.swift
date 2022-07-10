//
//  PiecesView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PiecesView: View {
   
   @Namespace
   private var namespace
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
      .aspectRatio(1, contentMode: .fit)
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
   
   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         PiecesView(
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
         .frame(width: 200, height: 225)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .foregroundColor(.cyan)
   }
}
