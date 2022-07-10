//
//  SelectedView.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import SwiftUI

struct SelectedView: View {
   
   let selected: (Position) -> UIColor?
   
   var body: some View {
      HStack(alignment: .center, spacing: 0, content: {
         ForEach(0 ... 7, id: \.self, content: { x in
            VStack(alignment: .center, spacing: 0, content: {
               ForEach(0 ... 7, id: \.self, content: { y in
                  let position = Position(x: x, y: y)
                  let color = selected(position) ?? .clear
                  SwiftUI.Color(color)
                     .border(.black, width: 1 / UIScreen.main.scale)
               })
            })
         })
      })
      .aspectRatio(1, contentMode: .fit)
      .allowsHitTesting(false)
   }
}

struct SelectedView_Previews: PreviewProvider {
   
   @Namespace
   static var namespace
   
   static var previews: some View {
      ZStack {
         SwiftUI.Color.cyan
         SelectedView(selected: { position in
            if position == .init(x: 0, y: 0) {
               return .yellow
            }
            if position == .init(x: 2, y: 7) {
               return .brown
            }
            return nil
         })
         .background(.orange)
         .frame(width: 175, height: 225)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .foregroundColor(.cyan)
   }
}
