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
            BoardView(select: { [weak viewModel] position in
               withAnimation {
                  viewModel?.select(position: position)
               }
            })
            SelectedView(selected: viewModel.selected)
            PiecesView(
               namespace: namespace,
               pieces: viewModel.pieces
            )
         }
         Spacer()

         let buttonTitle = viewModel.incorrect == nil ? "Check" : "Clear"
         Button(buttonTitle, action: { [weak viewModel] in
            viewModel?.check()
         })

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
