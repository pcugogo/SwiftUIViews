//
//  Array+.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import Foundation

extension Array {
    func enumeratedArray() -> [(offset: Int, element: Element)] {
        self.enumerated().asArray()
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
