//
//  Variety.swift
//  coloss
//
//  Created by Dev on 17.02.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Variety: Codable  {
    @DocumentID var id: String?
    var title: String
}
