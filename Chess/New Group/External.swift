//
//  Piece.swift
//  Chess
//
//  Created by iwheelbuy on 04.07.2022.
//

import Foundation

struct Move: Equatable {
   var from, to: Position
}

enum GameState {
   case idle
   case check
   case checkMate
   case staleMate
}

struct Game {
   private(set) var board: Board
   private(set) var history: [Move]
}

extension Game {
   var turn: Color {
      return history.last.flatMap {
         board.piece(at: $0.to)?.color.other
      } ?? .white
   }

   var state: GameState {
      let color = turn
      let canMove = allMoves(for: color).contains(where: { move in
         var newBoard = self
         newBoard.board.movePiece(from: move.from, to: move.to)
         return !newBoard.kingIsInCheck(for: color)
      })
      if kingIsInCheck(for: color) {
         return canMove ? .check : .checkMate
      }
      return canMove ? .idle : .staleMate
   }

   init() {
      board = Board()
      history = []
   }

   // MARK: Game logic

   func canSelectPiece(at position: Position) -> Bool {
      return board.piece(at: position)?.color == turn
   }

   func canMove(from: Position, by: Delta) -> Bool {
      return canMove(from: from, to: from + by)
   }

   func canMove(from: Position, to: Position) -> Bool {
      guard let this = board.piece(at: from) else {
         return false
      }
      let delta = to - from
      if let other = board.piece(at: to) {
         guard other.color != this.color else {
            return false
         }
         if this.type == .pawn {
            return pawnCanTake(from: from, with: delta)
         }
      }
      switch this.type {
      case .pawn:
         if enPassantTakePermitted(from: from, to: to) {
            return true
         }
         if delta.x != 0 {
            return false
         }
         switch this.color {
         case .white:
            if from.y == 6 {
               return [-1, -2].contains(delta.y) &&
               !board.piecesExist(between: from, and: to)
            }
            return delta.y == -1
         case .black:
            if from.y == 1 {
               return [1, 2].contains(delta.y) &&
               !board.piecesExist(between: from, and: to)
            }
            return delta.y == 1
         }
      case .rook:
         return (delta.x == 0 || delta.y == 0) &&
         !board.piecesExist(between: from, and: to)
      case .bishop:
         return abs(delta.x) == abs(delta.y) &&
         !board.piecesExist(between: from, and: to)
      case .queen:
         return (delta.x == 0 || delta.y == 0 || abs(delta.x) == abs(delta.y)) &&
         !board.piecesExist(between: from, and: to)
      case .king:
         if abs(delta.x) <= 1, abs(delta.y) <= 1 {
            return true
         }
         return castlingPermitted(from: from, to: to)
      case .knight:
         return [
            Delta(x: 1, y: 2),
            Delta(x: -1, y: 2),
            Delta(x: 2, y: 1),
            Delta(x: -2, y: 1),
            Delta(x: 1, y: -2),
            Delta(x: -1, y: -2),
            Delta(x: 2, y: -1),
            Delta(x: -2, y: -1),
         ].contains(delta)
      }
   }

   func pieceIsThreatened(at position: Position) -> Bool {
      return board.allPositions.contains(where: { canMove(from: $0, to: position) })
   }

   func positionIsThreatened(_ position: Position, by color: Color) -> Bool {
      return board.allPieces.contains(where: { from, piece in
         guard piece.color == color else {
            return false
         }
         if piece.type == .pawn {
            return pawnCanTake(from: from, with: position - from)
         }
         return canMove(from: from, to: position)
      })
   }

   func kingIsInCheck(for color: Color) -> Bool {
      if let position = board.firstPosition(where: {
         $0.type == .king && $0.color == color
      }) {
         return pieceIsThreatened(at: position)
      }
      return false
   }

   mutating func move(from: Position, to: Position) {
      assert(canMove(from: from, to: to))
      switch board.piece(at: from)?.type {
      case .pawn where enPassantTakePermitted(from: from, to: to):
         board.removePiece(at: Position(x: to.x, y: to.y - (to.y - from.y)))
      case .king where abs(to.x - from.x) > 1:
         let kingSide = (to.x == 6)
         let rookPosition = Position(x: kingSide ? 7 : 0, y: to.y)
         let rookDestination = Position(x: kingSide ? 5 : 3, y: to.y)
         board.movePiece(from: rookPosition, to: rookDestination)
      default:
         break
      }
      board.movePiece(from: from, to: to)
      history.append(Move(from: from, to: to))
   }

   func canPromotePiece(at position: Position) -> Bool {
      if let pawn = board.piece(at: position), pawn.type == .pawn,
         (pawn.color == .white && position.y == 0) ||
            (pawn.color == .black && position.y == 7) {
         return true
      }
      return false
   }

   mutating func promotePiece(at position: Position, to type: PieceType) {
      assert(canPromotePiece(at: position))
      board.promotePiece(at: position, to: type)
   }

   func movesForPiece(at position: Position) -> [Position] {
      return board.allPositions.filter { canMove(from: position, to: $0) }
   }

   // MARK: AI

   func nextMove(for color: Color) -> Move {
      var bestMove: Move?
      var bestState: GameState?
      var bestScore = 0.0
      for move in allMoves(for: color).shuffled() {
         var newBoard = self
         newBoard.move(from: move.from, to: move.to)
         if newBoard.kingIsInCheck(for: color) {
            continue
         }
         var newScore = Double(board.piece(at: move.to)?.type.value ?? 0)
         if newBoard.canPromotePiece(at: move.to) {
            newBoard.promotePiece(at: move.to, to: .queen)
            newScore += 8
         }
         switch newBoard.state {
         case .checkMate:
            break
         case .staleMate:
            if bestMove != nil {
               continue
            }
         case .check:
            if newBoard.pieceIsThreatened(at: move.to),
               let piece = newBoard.board.piece(at: move.to) {
               newScore -= Double(piece.type.value) * 0.9
            }
            switch bestState {
            case .check where newScore >= bestScore,
                  .idle where newScore >= bestScore,
                  .staleMate, nil:
               break
            case .check, .checkMate, .idle:
               continue
            }
         case .idle:
            var worstLossRisk = 0
            for (_, piece) in newBoard.allThreats(for: color) {
               worstLossRisk = max(worstLossRisk, piece.type.value)
            }
            newScore -= Double(worstLossRisk) * 0.9
            switch bestState {
            case .idle where newScore > bestScore,
                  .check where newScore > bestScore,
                  .staleMate, nil:
               break
            case .idle where newScore == bestScore && !newBoard.pieceIsThreatened(at: move.to):
               guard let bestMove = bestMove, let piece = board.piece(at: move.from) else {
                  break
               }
               // Encourage castling
               if piece.type == .king, abs(move.to.x - move.from.x) > 1 {
                  newScore += 0.5
                  break
               }
               // Discourage moving king or rook
               if [.king, .rook].contains(piece.type) {
                  continue
               }
               // All other things being equal, try to get pawn to other side
               if piece.type == .pawn, board.piece(at: bestMove.from)?.type != .pawn ||
                     (color == .black && move.to.y > bestMove.to.y) ||
                     (color == .white && move.to.y < bestMove.to.y) {
                  break
               }
               continue
            case .check, .checkMate, .idle:
               continue
            }
         }
         if bestMove != nil, history.count > 1,
            history.dropLast().last == Move(from: move.to, to: move.from) {
            continue
         }
         bestMove = move
         bestState = newBoard.state
         bestScore = newScore
      }
      return bestMove!
   }
}

private extension Game {
   func allMoves(for color: Color) ->
   LazySequence<FlattenSequence<LazyMapSequence<[Position], LazyFilterSequence<[Move]>>>> {
      return board.allPieces
         .compactMap { $1.color == color ? $0 : nil }
         .lazy.flatMap { self.allMoves(for: $0) }
   }

   func allMoves(for position: Position) -> LazyFilterSequence<[Move]> {
      return board.allPositions
         .map { Move(from: position, to: $0) }
         .lazy.filter { self.canMove(from: $0.from, to: $0.to) }
   }

   func allThreats(for color: Color) -> LazyFilterSequence<[(position: Position, piece: Piece)]> {
      return board.allPieces.lazy.filter { position, piece in
         return piece.color == color && self.pieceIsThreatened(at: position)
      }
   }

   func pawnCanTake(from: Position, with delta: Delta) -> Bool {
      guard abs(delta.x) == 1, let pawn = board.piece(at: from) else {
         return false
      }
      assert(pawn.type == .pawn)
      switch pawn.color {
      case .white:
         return delta.y == -1
      case .black:
         return delta.y == 1
      }
   }

   func enPassantTakePermitted(from: Position, to: Position) -> Bool {
      guard let this = board.piece(at: from),
            pawnCanTake(from: from, with: to - from),
            let lastMove = history.last, lastMove.to.x == to.x,
            let piece = board.piece(at: lastMove.to),
            piece.type == .pawn, piece.color != this.color
      else {
         return false
      }
      switch piece.color {
      case .white:
         return lastMove.from.y == to.y + 1 && lastMove.to.y == to.y - 1
      default:
         return lastMove.from.y == to.y - 1 && lastMove.to.y == to.y + 1
      }
   }

   func pieceHasMoved(at position: Position) -> Bool {
      return history.contains(where: { $0.from == position })
   }

   func castlingPermitted(from: Position, to: Position) -> Bool {
      guard let this = board.piece(at: from) else {
         return false
      }
      assert(this.type == .king)
      let kingsRow = this.color == .black ? 0 : 7
      guard from.y == kingsRow, to.y == kingsRow,
            from.x == 4, [2, 6].contains(to.x) else {
         return false
      }
      let kingPosition = Position(x: 4, y: kingsRow)
      if pieceHasMoved(at: kingPosition) {
         return false
      }
      let isKingSide = (to.x == 6)
      let rookPosition = Position(x: isKingSide ? 7 : 0, y: kingsRow)
      if pieceHasMoved(at: rookPosition) {
         return false
      }
      return !(isKingSide ? 5 ... 6 : 1 ... 3).contains(where: {
         board.piece(at: Position(x: $0, y: kingsRow)) != nil
      }) && !(isKingSide ? 4 ... 6 : 2 ... 4).contains(where: {
         positionIsThreatened(Position(x: $0, y: kingsRow), by: this.color.other)
      })
   }
}

private extension Board {
   func piecesExist(between: Position, and: Position) -> Bool {
      let step = Delta(
         x: between.x > and.x ? -1 : (between.x < and.x ? 1 : 0),
         y: between.y > and.y ? -1 : (between.y < and.y ? 1 : 0)
      )
      var position = between
      position += step
      while position != and {
         if piece(at: position) != nil {
            return true
         }
         position += step
      }
      return false
   }
}

enum PieceType: String {
   case pawn
   case rook
   case knight
   case bishop
   case queen
   case king

   var value: Int {
      switch self {
      case .pawn:
         return 1
      case .knight, .bishop:
         return 3
      case .rook:
         return 5
      case .queen:
         return 9
      case .king:
         return 0
      }
   }
}

enum Color: String {
   case white
   case black

   var other: Color {
      return self == .black ? .white : .black
   }
}

struct Piece: Equatable, ExpressibleByStringLiteral {
   let id: String
   var type: PieceType
   let color: Color

   init(stringLiteral: String) {
      id = stringLiteral
      let chars = Array(stringLiteral)
      precondition(chars.count == 3)
      switch chars[0] {
      case "B": color = .black
      case "W": color = .white
      default:
         preconditionFailure()
      }
      switch chars[1] {
      case "P": type = .pawn
      case "R": type = .rook
      case "N": type = .knight
      case "B": type = .bishop
      case "Q": type = .queen
      case "K": type = .king
      default:
         preconditionFailure()
      }
   }
}

struct Delta: Hashable {
   var x, y: Int
}

struct Position: Hashable {
   var x, y: Int

   static func - (lhs: Position, rhs: Position) -> Delta {
      return Delta(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
   }

   static func + (lhs: Position, rhs: Delta) -> Position {
      return Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
   }

   static func += (lhs: inout Position, rhs: Delta) {
      lhs.x += rhs.x
      lhs.y += rhs.y
   }
}

struct Board: Equatable {
   private(set) var pieces: [[Piece?]]
}

extension Board {
   static let allPositions = (0 ..< 8).flatMap { y in
      (0 ..< 8).map { Position(x: $0, y: y) }
   }

   var allPositions: [Position] { return Self.allPositions }

   var allPieces: [(position: Position, piece: Piece)] {
      return allPositions.compactMap { position in
         pieces[position.y][position.x].map { (position, $0) }
      }
   }

   init() {
      pieces = [
         ["BR0", "BN1", "BB2", "BQ3", "BK4", "BB5", "BN6", "BR7"],
         ["BP0", "BP1", "BP2", "BP3", "BP4", "BP5", "BP6", "BP7"],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         [nil, nil, nil, nil, nil, nil, nil, nil],
         ["WP0", "WP1", "WP2", "WP3", "WP4", "WP5", "WP6", "WP7"],
         ["WR0", "WN1", "WB2", "WQ3", "WK4", "WB5", "WN6", "WR7"],
      ]
   }

   func piece(at position: Position) -> Piece? {
      guard (0 ..< 8).contains(position.y), (0 ..< 8).contains(position.x) else {
         return nil
      }
      return pieces[position.y][position.x]
   }

   func firstPosition(where condition: (Piece) -> Bool) -> Position? {
      return allPieces.first(where: { condition($1) })?.position
   }

   mutating func movePiece(from: Position, to: Position) {
      var pieces = self.pieces
      pieces[to.y][to.x] = piece(at: from)
      pieces[from.y][from.x] = nil
      self.pieces = pieces
   }

   mutating func removePiece(at position: Position) {
      var pieces = self.pieces
      pieces[position.y][position.x] = nil
      self.pieces = pieces
   }

   mutating func promotePiece(at position: Position, to type: PieceType) {
      var piece = self.piece(at: position)
      piece?.type = type
      pieces[position.y][position.x] = piece
   }
}