//
//  ContentViewModel.swift
//  Chess
//
//  Created by iwheelbuy on 06.07.2022.
//

import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {

   private var game: Game
   @Published
   private(set) var pieces: [Position: Piece] = [:]
   @Published
   private(set) var taken: [Position: Piece] = [:]
   @Published
   var selected: Position?

   init() {
      game = .init(
         board: .init(),
         history: []
      )
      pieces = getPieces()
   }

   func select(position: Position) {
      let piecesPrevious = pieces
      defer {
//         print("~~|", self.selected)
      }
      if let selected = self.selected {
         if game.canMove(from: selected, to: position) {
            game.move(from: selected, to: position)
            pieces = getPieces()
            print("~~|", taken)
            taken = piecesPrevious
               .filter({ _, piece in
                  pieces.contains(where: { $0.value.id == piece.id }) == false
               })
               .reduce(into: taken, { pieces, object in
                  pieces[object.key] = object.value
               })
            print("~~|", taken)
         }
         self.selected = nil
      } else if game.board.piece(at: position) != nil {
         self.selected = position
      } else {
         self.selected = nil
      }
   }

   func getPieces() -> [Position: Piece] {
      return game.board
         .allPositions
         .reduce(into: [Position: Piece]()) { dictionary, position in
            dictionary[position] = game.board.piece(at: position)
         }
   }
}
