//
//  FilesRanksView.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import SwiftUI

struct FilesRanksView: View {

   var body: some View {
      HStack(alignment: .center, spacing: 0, content: {
         ForEach(0 ... 7, id: \.self, content: { x in
            VStack(alignment: .center, spacing: 0, content: {
               ForEach(0 ... 7, id: \.self, content: { y in
                  let position = Position(x: x, y: y)
                  ZStack {
                     filesView(position: position)
                     ranksView(position: position)
                  }
               })
            })
         })
      })
      .aspectRatio(1, contentMode: .fit)
      .allowsHitTesting(false)
   }

   @ViewBuilder
   private func ranksView(position: Position) -> some View {
      let text: String = {
         if position.x == 0 {
            return "\(8 - position.y)"
         }
         return ""
      }()
      textView(text: text) { size in
         CGPoint(
            x: size.width * 0.11,
            y: size.height * 0.11
         )
      }
   }

   @ViewBuilder
   private func filesView(position: Position) -> some View {
      let text: String = {
         guard position.y == 7 else {
            return ""
         }
         switch position.x {
         case 0:
            return "a"
         case 1:
            return "b"
         case 2:
            return "c"
         case 3:
            return "d"
         case 4:
            return "e"
         case 5:
            return "f"
         case 6:
            return "g"
         default:
            return "h"
         }
      }()
      textView(text: text) { size in
         CGPoint(
            x: size.width * 0.89,
            y: size.height * 0.89
         )
      }
   }

   @ViewBuilder
   private func textView(
      text: String,
      position: @escaping (CGSize) -> CGPoint
   ) -> some View {
      GeometryReader { geometry in
         Text(text)
            .foregroundColor(.black)
            .font(.system(size: 100, weight: .bold))
            .position(
               position(geometry.size)
            )
            .minimumScaleFactor(0.01)
            .frame(
               width: geometry.size.width * 0.22,
               height: geometry.size.height * 0.22,
               alignment: .center
            )
      }
   }
}

struct FilesRanksView_Previews: PreviewProvider {

   @Namespace
   static var namespace

   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         FilesRanksView()
            .background(.orange)
            .frame(width: 175, height: 225)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .foregroundColor(.cyan)
   }
}
