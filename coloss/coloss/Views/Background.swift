//
//  Background.swift
//  coloss
//
//  Created by Dev on 14.02.24.
//

import SwiftUI

struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .overlay(content)
    }
}
