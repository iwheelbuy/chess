//
//  MenuView.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import SwiftUI

struct MenuView: View {

   let gameType: GameType
   let select: (GameType) -> Void

   var body: some View {
      GeometryReader { geometry in
         VStack(alignment: .center, spacing: 20, content: {
            ForEach(GameType.all, id: \.self, content: { gameType in
               let active = gameType == self.gameType
               ZStack {
                  SwiftUI.Color(active ? .systemOrange : .lightGray)
                     .cornerRadius(geometry.size.width * 0.8 / 2)
                  Image(gameType.rawValue)
                     .resizable()
                     .scaledToFit()
                     .foregroundColor(.black)
                     .frame(
                        width: geometry.size.width * 0.5,
                        height: geometry.size.width * 0.5
                     )
               }
               .frame(
                  width: geometry.size.width * 0.8,
                  height: geometry.size.width * 0.8
               )
               .cornerRadius(geometry.size.width * 0.8 / 2)
               .allowsHitTesting(active == false)
               .onTapGesture(count: 1) {
                  select(gameType)
               }
            })
         })
         .position(
            CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
         )
      }
   }
}

struct MenuView_Previews: PreviewProvider {

   static var previews: some View {
      MenuView(gameType: .protected, select: { _ in })
         .background(.cyan)
         .previewLayout(.fixed(width: 300, height: 300))
         .frame(width: 50, height: 300)
   }
}
