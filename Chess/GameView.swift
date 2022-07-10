//
//  GameView.swift
//  Chess
//
//  Created by iwheelbuy on 03.07.2022.
//

import SwiftUI

struct GameView: View {
   
   @ObservedObject
   private var viewModel = GameViewModel(gameType: .alone)

   var body: some View {
      GeometryReader { geometry in
         HStack(alignment: .center, spacing: 0, content: {
            MenuView(
               gameType: viewModel.gameType,
               select: { [weak viewModel] gameType in
                  viewModel?.update(gameType: gameType)
               }
            )
            gameView(geometry: geometry)
            ActionView(
               active: Set([viewModel.completed == nil ? .check : .update]),
               available: [.check, .update],
               select: { [weak viewModel] _ in
                  viewModel?.check()
               }
            )
         })
         .position(
            CGPoint(
               x: geometry.size.width / 2,
               y: geometry.size.height / 2
            )
         )
      }
      .background(SwiftUI.Color.black)
   }

   @ViewBuilder
   func gameView(geometry: GeometryProxy) -> some View {
      ZStack(alignment: .center) {
         BoardView(select: { [weak viewModel] position in
            withAnimation {
               viewModel?.select(position: position)
            }
         })
         SelectedView { position in
            if let completed = viewModel.completed {
               if completed.correct.contains(position) {
                  return .systemGreen
               } else if completed.incorrect.contains(position) {
                  return .systemRed
               } else if completed.missed.contains(position) {
                  return .systemCyan
               } else {
                  return nil
               }
            } else if viewModel.selected.contains(position) {
               return .systemPurple
            } else {
               return nil
            }
         }
         PiecesView(
            pieces: viewModel.pieces
         )
         FilesRanksView()
      }
      .frame(
         width: geometry.size.height,
         height: geometry.size.height,
         alignment: .center
      )
   }
}

struct GameView_Previews: PreviewProvider {
   
   static var previews: some View {
      GameView()
         .previewInterfaceOrientation(.landscapeLeft)
   }
}
