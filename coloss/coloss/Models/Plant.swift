//
//  Plant.swift
//  coloss
//
//  Created by Dev on 14.02.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Plant: Codable  {
    @DocumentID var id: String?
    var title: String
    var categoryId: String?
    var imageId: String?
}
