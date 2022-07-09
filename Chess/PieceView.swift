//
//  PieceView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct PieceView: View {

   let namespace: Namespace.ID?
   let piece: Piece

   var body: some View {
      if let namespace = namespace {
         pieceView()
            .matchedGeometryEffect(id: piece.id.uuidString, in: namespace)
      } else {
         pieceView()
      }
   }

   @ViewBuilder
   private func pieceView() -> some View {
      GeometryReader { metrics in
         SwiftUI.Image(piece.type.rawValue)
            .resizable()
            .foregroundColor(piece.color == .white ? .white : .black)
            .scaledToFit()
            .frame(
               width: side(metrics: metrics),
               height: side(metrics: metrics)
            )
            .position(x: metrics.size.width / 2, y: metrics.size.height / 2)
      }
   }

   private func side(metrics: GeometryProxy) -> CGFloat {
      return min(metrics.size.width, metrics.size.height) * 0.8
   }
}

struct PieceView_Previews: PreviewProvider {

   static var previews: some View {
      PieceView(namespace: nil, piece: .init(color: .black, type: .rook))
         .background(.cyan)
         .previewLayout(.fixed(width: 200, height: 200))
         .frame(width: 50, height: 100)
   }
}
