//
//  SelectedView.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import SwiftUI

struct SelectedView: View {

   let color: UIColor = .green
   var selected: Set<Position>

   var body: some View {
      HStack(alignment: .center, spacing: 0, content: {
         ForEach(0 ... 7, id: \.self, content: { x in
            VStack(alignment: .center, spacing: 0, content: {
               ForEach(0 ... 7, id: \.self, content: { y in
                  let position = Position(x: x, y: y)
                  if selected.contains(position) {
                     SwiftUI.Color(color)
                        .border(.black, width: 1)
                  } else {
                     SwiftUI.Color.clear
                  }
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
         SelectedView(
            selected: Set(
               [
                  Position.init(x: 0, y: 0),
                  Position.init(x: 2, y: 7)
               ]
            )
         )
         .background(.orange)
         .frame(width: 175, height: 225)
      }
      .previewLayout(.fixed(width: 250, height: 250))
      .foregroundColor(.cyan)
   }
}
