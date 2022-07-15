//
//  GameType.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import Foundation

enum GameType: String, Hashable, Identifiable {

   case alone
   case protected
   case taken

   var id: String {
      return rawValue
   }

   static var all: [GameType] {
      return [.alone, .protected, .taken]
   }
}
