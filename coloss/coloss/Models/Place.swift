//
//  Place.swift
//  coloss
//
//  Created by Dev on 8.02.24.
//

import Foundation
import FirebaseFirestoreSwift

struct Place: Codable {
    @DocumentID var id: String?
    var title: String
    var description: String?
    var imageId: String?
}

extension Place {
    static let mocPlaces = [
        Place(id: "some id1", title: "House", description: "Village Moscow region"),
        Place(id: "some id2", title: "Apartment", description: "Moscow City"),
        ]
}
