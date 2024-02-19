//
//  Optoinal+Bool.swift
//  coloss
//
//  Created by Dev on 9.02.24.
//

import Foundation
extension Optional {
    var isNil: Bool {
        return self == nil
    }
    
    var isNotNil: Bool {
        return self != nil
    }
}

extension Optional where Wrapped == String {
    var isNil: Bool {
        if self == nil {
            return true
        } else {
            return false
        }
    }
}
