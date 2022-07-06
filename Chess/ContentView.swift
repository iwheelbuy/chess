//
//  ContentView.swift
//  Chess
//
//  Created by iwheelbuy on 03.07.2022.
//

import SwiftUI

struct ContentView: View {
   
   var body: some View {
      VStack(alignment: .center, spacing: 0, content: {
         Spacer()
         HStack(alignment: .center, spacing: 0, content: {
            ForEach((1 ... 8).reversed(), id: \.self, content: { row in
               VStack(alignment: .center, spacing: 0, content: {
                  ForEach((1 ... 8).reversed(), id: \.self, content: { line in
                     let white = (row + line) % 2 == 0
                     if white {
                        SwiftUI.Color.yellow
                     } else {
                        SwiftUI.Color.black
                     }
                  })
               })
            })
         })
         .aspectRatio(1, contentMode: .fit)
         Spacer()
      })
      .background(SwiftUI.Color.cyan)
   }
}

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      ContentView()
   }
}
