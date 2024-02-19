//
//  PlaceView.swift
//  coloss
//
//  Created by Dev on 13.02.24.
//

import SwiftUI

struct PlaceView: View {
    
    @Environment(\.networkAPI) var networkService
    @State var showAddNewPlant = false
    
    @State var place: Place?
    let placeId: String
    
    var body: some View {
        ScrollView {
            VStack {
                PlantsListView(placeId: placeId, groupId: nil)
            }
            .task {
                place = await networkService.getPlace(by: placeId)
            }
        }
        .navigationTitle(Text(place?.title ?? ""))
        .toolbar {
            Button {
                showAddNewPlant.toggle()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .sheet(isPresented: $showAddNewPlant) {
            NewPlantView(placeId: placeId)
        }
    }
    
    func addPlant() {
        Task {
            let plant = Plant(title: "Plant \(String.generateRandom(size: 6))")
            try? await networkService.addPlant(plant, placeId: placeId, groupId: nil)
        }
        
    }
    
}

#Preview {
    PlaceView(placeId: "sdf")
}
