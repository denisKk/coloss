//
//  Group.swift
//  coloss
//
//  Created by Dev on 14.02.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Codable {
    var id: String
    var title: String
    var description: String?
}
