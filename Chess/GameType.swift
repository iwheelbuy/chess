//
//  GameType.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import Foundation

enum GameType: String, Hashable, Identifiable {

   case alone
   case major
   case protected
   case taken

   var range: ClosedRange<Int> {
      switch self {
      case .alone:
         return 10 ... 15
      case .protected:
         return 10 ... 15
      case .major:
         return 15 ... 22
      case .taken:
         return 10 ... 15
      }
   }

   var id: String {
      return rawValue
   }

   static var all: [GameType] {
      return [.alone, .protected, .taken, .major]
   }
}
