//
//  ActionView.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import SwiftUI

struct ActionView: View {

   let active: Set<ActionType>
   let available: [ActionType]
   let select: (ActionType) -> Void

   var body: some View {
      GeometryReader { geometry in
         VStack(alignment: .center, spacing: 20, content: {
            ForEach(available, id: \.self, content: { current in
               let active = self.active.contains(current)
               ZStack(alignment: SwiftUI.Alignment.center, content: {
                  SwiftUI.Color(active ? .systemGreen : .lightGray)
                     .cornerRadius(geometry.size.width * 0.8 / 2)
                  Image(current.rawValue)
                     .resizable()
                     .scaledToFit()
                     .foregroundColor(.black)
                     .frame(
                        width: geometry.size.width * 0.5,
                        height: geometry.size.width * 0.5
                     )
               })
               .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
               .cornerRadius(geometry.size.width * 0.8 / 2)
               .allowsHitTesting(active)
               .onTapGesture(count: 1) {
                  select(current)
               }
            })
         })
         .position(
            CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
         )
      }
   }
}

struct ActionView_Previews: PreviewProvider {

   static var previews: some View {
      ActionView(
         active: Set([.check]),
         available: [.check, .update],
         select: { _ in }
      )
      .background(.cyan)
      .previewLayout(.fixed(width: 300, height: 300))
      .frame(width: 50, height: 300)
   }
}
