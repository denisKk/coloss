//
//  PlantsRepository.swift
//  coloss
//
//  Created by Dev on 12.02.24.
//

import Foundation
import Combine
import FirebaseFirestore

final class PlantsRepository: ObservableObject {
    
    @Published var plantsIndexes: [String] = .init()
    
    var cancellables: Set<AnyCancellable> = []
    
    let subscriptionID: String = UUID().uuidString
    
    
    func startSubscription(path: String) {
        print("start")
        FirestoreSubscription.subscribeDocument(id: subscriptionID, path: path)
            .compactMap(FirestoreDecoder.decodeDoc(SortIndexes.self))
            .receive(on: DispatchQueue.main)
            .map({$0.positions ?? []})
            .sink(receiveValue: {[weak self] indexes in
                self?.plantsIndexes = indexes            })
            .store(in: &cancellables)
    }
    
    func stopSubscription() {
        print("stop")
        FirestoreSubscription.cancel(id: subscriptionID)
    }
    
    init() {
        
        
    }
    
}


