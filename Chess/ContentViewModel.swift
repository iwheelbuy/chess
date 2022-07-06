//
//  ContentViewModel.swift
//  Chess
//
//  Created by iwheelbuy on 06.07.2022.
//

import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {

   @Published
   var selected: Position? = .init(x: 0, y: 0)

   var game: Game = .init(
      board: .init(),
      history: []
   )

   func select(position: Position) {
      if let selected = self.selected {
         if game.canMove(from: selected, to: position) {
            game.move(from: selected, to: position)
         }
         self.selected = nil
      } else if game.board.piece(at: position) != nil {
         self.selected = position
      } else {
         self.selected = nil
      }
   }
}
