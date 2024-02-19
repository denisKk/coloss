//
//  Category.swift
//  coloss
//
//  Created by Dev on 17.02.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Category: Codable, Identifiable, Equatable  {
    @DocumentID var id: String?
    var title: String
}
