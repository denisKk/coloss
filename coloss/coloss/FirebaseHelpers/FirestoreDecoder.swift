//
//  FirestoreDecoder.swift
//  coloss
//
//  Created by Dev on 12.02.24.
//

import Foundation
import FirebaseFirestore

struct FirestoreDecoder {
    static func decodeColl<T: Collection>(_ type: T.Type) -> (QuerySnapshot) -> T? where T.Element: Decodable {
        { snapshot in
            var results: [T.Element] = []
            
            for doc in snapshot.documents {
                if let i = try? doc.data(as: type.Element) {
                    results.append(i)
                }
            }
            return results as? T
        }
    }
    
    static func decodeDoc<T>(_ type: T.Type) -> (DocumentSnapshot) -> T? where T: Decodable {
        { snapshot in
            return try? snapshot.data(as: type)
        }
    }
}


