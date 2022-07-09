//
//  BoardView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct BoardView: View {

   var selected: Position?
   var select: (Position) -> Void

   var body: some View {
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
   }

   @ViewBuilder
   private func squareView(position: Position) -> some View {
      let view: SwiftUI.Color = {
         if selected == position {
            return SwiftUI.Color.green
         } else {
            let white = (position.x + position.y) % 2 == 0
            return white ? SwiftUI.Color.yellow : SwiftUI.Color.brown
         }
      }()
      view
         .onTapGesture(count: 1) {
            select(position)
         }
   }
}

struct BoardView_Previews: PreviewProvider {

   @Namespace
   static var namespace

   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         BoardView(select: { _ in })
            .background(.orange)
            .frame(width: 175, height: 225)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .foregroundColor(.cyan)
   }
}
