//
//  ActionType.swift
//  Chess
//
//  Created by iwheelbuy on 10.07.2022.
//

import Foundation

enum ActionType: String, Identifiable, Hashable {

   case check
   case update

   var id: String {
      return rawValue
   }

   static var all: [ActionType] {
      return [.check, .update]
   }
}
