//
//  BoardView.swift
//  Chess
//
//  Created by iwheelbuy on 07.07.2022.
//

import SwiftUI

struct BoardView: View {

   var black: UIColor = UIColor(
      red: 128 / 255,
      green: 23 / 255,
      blue: 181 / 255,
      alpha: 1
   )
   var white: UIColor = UIColor(
      red: 205 / 255,
      green: 31 / 255,
      blue: 199 / 255,
      alpha: 1
   )
   var select: (Position) -> Void
   
   var body: some View {
      HStack(alignment: .center, spacing: 0, content: {
         ForEach(0 ... 7, id: \.self, content: { x in
            VStack(alignment: .center, spacing: 0, content: {
               ForEach(0 ... 7, id: \.self, content: { y in
                  let position = Position(x: x, y: y)
                  squareView(position: position)
                     .border(.black, width: 1 / UIScreen.main.scale)
                     .onTapGesture(count: 1) {
                        select(position)
                     }
               })
            })
         })
      })
      .aspectRatio(1, contentMode: .fit)
   }
   
   @ViewBuilder
   private func squareView(position: Position) -> some View {
      let white = (position.x + position.y) % 2 == 0
      SwiftUI.Color(white ? self.white : self.black)
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
