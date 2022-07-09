//
//  PieceView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PieceView: View {

   let namespace: Namespace.ID
   let piece: Piece

   var body: some View {
      GeometryReader { geometry in
         let side = min(geometry.size.width, geometry.size.height) * 0.8
         SwiftUI.Image(piece.type.rawValue)
            .resizable()
            .foregroundColor(piece.color == .white ? .white : .black)
            .scaledToFit()
            .frame(width: side, height: side)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .matchedGeometryEffect(id: piece.id.uuidString, in: namespace)
      }
   }
}

struct PieceView_Previews: PreviewProvider {

   @Namespace
   static var namespace

   static var previews: some View {
      PieceView(namespace: namespace, piece: .init(color: .black, type: .rook))
         .background(.cyan)
         .previewLayout(.fixed(width: 200, height: 200))
         .frame(width: 50, height: 100)
   }
}
