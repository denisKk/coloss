//
//  String+ID.swift
//  coloss
//
//  Created by Dev on 6.02.24.
//

import SwiftUI

extension String {
    static func generateRandom(size: Int) -> String {
        let flag = Bool.random()
        let uuidString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let prefixSize = flag ? size : uuidString.count
        let suffixSize = flag ? uuidString.count : size
        
        return String(Data(uuidString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "=", with: "")
            .prefix(Int(prefixSize))
            .suffix(suffixSize))
    }
}
