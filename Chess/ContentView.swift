//
//  ContentView.swift
//  Chess
//
//  Created by iwheelbuy on 03.07.2022.
//

import SwiftUI

struct ContentView: View {

   @ObservedObject private var viewModel = ContentViewModel()
   @Namespace private var current
   @Namespace private var taken

   init() {
   }
   
   var body: some View {
      VStack(alignment: .center, spacing: 0, content: {
         Spacer()
         ZStack(alignment: .center) {
            BoardView(selected: viewModel.selected) { [weak viewModel] position in
               withAnimation(SwiftUI.Animation.linear(duration: 2)) {
                  viewModel?.select(position: position)
               }
            }
            PiecesView(
               current: current,
               taken: taken,
               pieces: viewModel.pieces,
               piecesTaken: viewModel.piecesTaken
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
