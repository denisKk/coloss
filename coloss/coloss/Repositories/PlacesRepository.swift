//
//  PlacesRepository.swift
//  coloss
//
//  Created by Dev on 12.02.24.
//

import Foundation
import Combine
import FirebaseFirestore

final class PlacesRepository: ObservableObject {
    
    @Published var placeIndexes: [String] = .init()

    var cancellables: Set<AnyCancellable> = []
    
    let subscriptionID: String = UUID().uuidString
    
    func startSubscription(path: String) {
        FirestoreSubscription.subscribeDocument(id: subscriptionID, path: path)
            .compactMap(FirestoreDecoder.decodeDoc(SortIndexes.self))
            .receive(on: DispatchQueue.main)
            .map({$0.positions ?? []})
            .sink(receiveValue: {[weak self] indexes in
                self?.placeIndexes = indexes
            })
            .store(in: &cancellables)
    }
    
    func stopSubscription() {
        FirestoreSubscription.cancel(id: subscriptionID)
    }
    
    func removeRows(at offsets: IndexSet) {
        placeIndexes.remove(atOffsets: offsets)
    }
}
