//
//  GameViewModel.swift
//  Chess
//
//  Created by iwheelbuy on 06.07.2022.
//

import SwiftUI

final class GameViewModel: ObservableObject {

   struct Completed {

      let correct: Set<Position>
      let incorrect: Set<Position>
      let missed: Set<Position>

      var isValid: Bool {
         return !correct.isEmpty || !incorrect.isEmpty || !missed.isEmpty
      }
   }

   private var game: Game!
   @Published
   private(set) var gameType: GameType = .alone
   @Published
   private(set) var pieces: [Position: Piece] = [:]
   @Published
   private(set) var selected: Set<Position> = Set()
   @Published
   private(set) var completed: Completed? = nil
   
   init(gameType: GameType) {
      self.gameType = gameType
      generate()
   }
   
   func check() {
      if completed == nil {
         let matching = Self.getMatching(game: game, gameType: gameType)
         completed = .init(
            correct: selected.intersection(matching),
            incorrect: selected.subtracting(matching),
            missed: matching.subtracting(selected)
         )
      } else {
         generate()
      }
   }

   static func getMatching(game: Game, gameType: GameType) -> Set<Position> {
      let array = game.board.allPositions
         .filter({ position in
            switch gameType {
            case .alone:
               return isAlone(game: game, position: position)
            case .major:
               return isMajor(game: game, position: position)
            case .protected:
               return isProtected(game: game, position: position)
            case .taken:
               return isAlone(game: game, position: position) && isAtRisk(game: game, position: position)
            }
         })
      return Set(array)
   }

   func update(gameType: GameType) {
      self.gameType = gameType
      generate()
   }

   func getRandomPieces() -> [Position: Piece] {
      var original = Board.standart.allPieces
         .map({ $0.piece })
         .filter({ $0.type != .king })
      let count = Int.random(in: gameType.range)
      var array: [Piece] = []
      while array.count < count {
         let index = Int.random(in: 0 ..< original.count)
         let piece = original.remove(at: index)
         array += [piece]
      }
      var pieces = [Position: Piece]()
      array.shuffle()
      while array.isEmpty == false {
         if let index = array.firstIndex(where: { $0.type == .pawn }) {
            let piece = array[index]
            let y = Int.random(in: 1 ... 6)
            let x = Int.random(in: 0 ... 7)
            let position = Position(x: x, y: y)
            guard pieces[position] == nil else {
               continue
            }
            pieces[position] = piece
            array.remove(at: index)
         } else {
            let piece = array[0]
            let y = Int.random(in: 0 ... 7)
            let x = Int.random(in: 0 ... 7)
            let position = Position(x: x, y: y)
            guard pieces[position] == nil else {
               continue
            }
            if
               piece.type == .bishop,
               pieces.contains(where: { $0.value.type == .bishop && $0.value.color == piece.color && $0.key.color == position.color })
            {
               continue // bishops can't be on squares of same color
            }
            pieces[position] = piece
            array.remove(at: 0)
         }
      }
      for piece in [Piece(color: .black, type: .king), .init(color: .white, type: .king)] {
         while true {
            let y = Int.random(in: 0 ... 7)
            let x = Int.random(in: 0 ... 7)
            let position = Position(x: x, y: y)
            guard pieces[position] == nil else {
               continue
            }
            var piecesTest = pieces
            piecesTest[position] = piece
            let game = Game(board: .init(pieces: piecesTest), history: [])
            if [Color.black, .white].contains(where: { game.kingIsInCheck(for: $0) }) {
               continue
            }
            pieces[position] = piece
            break
         }
      }
      return pieces
   }

   func generate() {
      var game: Game!
      var pieces: [Position: Piece]!
      repeat {
         pieces = getRandomPieces()
         game = .init(
            board: .init(pieces: pieces),
            history: []
         )
      } while Self.getMatching(game: game, gameType: gameType).isEmpty
      self.completed = nil
      self.game = game
      self.pieces = pieces
      self.selected = Set()
   }
   
   func select(position: Position) {
      guard let piece = game.board.piece(at: position) else {
         return
      }
      if piece.type == .king {
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
   
   static func isAlone(game gameOriginal: Game, position: Position) -> Bool {
      guard let piece = gameOriginal.board.piece(at: position) else {
         return false
      }
      guard piece.type != .king else {
         return false
      }
      var pieces = gameOriginal.board.allPieces
         .reduce(into: [Position: Piece](), { pieces, object in
            pieces[object.position] = object.piece
         })
      pieces[position] = .init(color: piece.color.other, type: .pawn)
      let board = Board(pieces: pieces)
      let game = Game(board: board, history: [])
      guard let piece = game.board.piece(at: position) else {
         return false
      }
      return game.positionIsThreatened(position, by: piece.color.other) == false
   }

   static func isProtected(game gameOriginal: Game, position: Position) -> Bool {
      guard let piece = gameOriginal.board.piece(at: position) else {
         return false
      }
      guard piece.type != .king else {
         return false
      }
      var pieces = gameOriginal.board.allPieces
         .reduce(into: [Position: Piece](), { pieces, object in
            pieces[object.position] = object.piece
         })
      pieces[position] = .init(color: piece.color.other, type: .pawn)
      let board = Board(pieces: pieces)
      let game = Game(board: board, history: [])
      guard let piece = game.board.piece(at: position) else {
         return false
      }
      return game.positionIsThreatened(position, by: piece.color.other) == true
   }

   static func isAtRisk(game gameOriginal: Game, position: Position) -> Bool {
      guard let piece = gameOriginal.board.piece(at: position) else {
         return false
      }
      guard piece.type != .king else {
         return false
      }
      return gameOriginal.positionIsThreatened(position, by: piece.color.other) == true
   }

   static func isMajor(game gameOriginal: Game, position: Position) -> Bool {
      guard let piece = gameOriginal.board.piece(at: position) else {
         return false
      }
      return [PieceType.bishop, .knight, .queen, .rook].contains(piece.type)
   }
}
