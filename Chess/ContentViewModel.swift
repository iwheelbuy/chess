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
   private(set) var selected: Set<Position> = Set()
   @Published
   private(set) var incorrect: Set<Position>?

   init() {
      game = .init(
         board: .init(
            pieces: [
               .init(x: 0, y: 1): .init(color: .white, type: .king),
               .init(x: 5, y: 3): .init(color: .white, type: .pawn),
               .init(x: 6, y: 2): .init(color: .white, type: .pawn),
               .init(x: 3, y: 3): .init(color: .black, type: .king),
               .init(x: 6, y: 1): .init(color: .black, type: .pawn),
               .init(x: 4, y: 0): .init(color: .black, type: .knight)
            ]
         ),
         history: []
      )
      pieces = getPieces()
   }

   func check() {
      if incorrect == nil {
         let allPositions = game.board.allPositions
            .filter({ game.board.piece(at: $0) != nil })
         let allUnprotected = allPositions
            .compactMap({ position -> Position? in
               guard let piece = game.board.piece(at: position) else {
                  return nil
               }
               if game.positionIsThreatened(position, by: piece.color) {
                  return nil // protected
               }
               return position
            })
         incorrect = Set<Position>(allUnprotected).subtracting(selected)
      } else {
         incorrect = nil
         selected = Set()
      }
   }

   func select(position: Position) {
      guard game.board.piece(at: position) != nil else {
         return
      }
      if selected.insert(position).inserted == false {
         selected.remove(position)
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
