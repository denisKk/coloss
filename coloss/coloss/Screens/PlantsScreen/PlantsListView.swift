//
//  PlantsListView.swift
//  coloss
//
//  Created by Dev on 11.02.24.
//

import SwiftUI

struct PlantsListView: View {
    
    @StateObject private var plantsRepo: PlantsRepository = .init()
    @Environment(\.networkAPI) var networkService
    @EnvironmentObject var router: Router
    
    let placeId: String?
    let groupId: String?
    
    
    
    var body: some View {
//        ScrollView(.vertical) {
            LazyVStack {
                ForEach(plantsRepo.plantsIndexes, id: \.self) { plantId in
                    PlantListRowView(plantId: plantId)
                        .onTapGesture(count: 2) {
                            Task {
                                try? await networkService.deletePlant(by:plantId, placeId: placeId ?? "", groupId: nil)
                            }
                        }
                        .onTapGesture(count: 1, perform: {
                            router.plantRoutes.append(.plant(plantId))
                        })
                        .transition(.move(edge: .leading))
                        .animation(.bouncy, value: plantsRepo.plantsIndexes)
                }
            }
//        }
        .onAppear {
            if let placeId = placeId {
                plantsRepo.startSubscription(path: networkService.getPlantsPath(with: placeId))
            }
        }
        .onDisappear{
            plantsRepo.stopSubscription()
        }
    }
}

#Preview {
    PlantsListView(placeId: "asdfasdfa", groupId: "")
}
