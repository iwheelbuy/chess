//
//  ContentView.swift
//  Chess
//
//  Created by iwheelbuy on 03.07.2022.
//

import SwiftUI

struct ContentView: View {

   @ObservedObject private var viewModel = ContentViewModel()
   @Namespace private var namespace

   init() {
   }
   
   var body: some View {
      VStack(alignment: .center, spacing: 0, content: {
         Spacer()
         ZStack(alignment: .center) {
            BoardView(selected: viewModel.selected) { [weak viewModel] position in
//               withAnimation(SwiftUI.Animation.linear(duration: 0.5)) {
               withAnimation {
                  viewModel?.select(position: position)
               }
            }
            PiecesView(
               namespace: namespace,
               pieces: viewModel.pieces
            )
         }
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
