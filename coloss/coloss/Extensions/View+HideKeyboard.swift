//
//  View+HideKeyboard.swift
//  coloss
//
//  Created by Dev on 14.02.24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
