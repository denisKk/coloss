//
//  PlacesListView.swift
//  coloss
//
//  Created by Dev on 12.02.24.
//

import SwiftUI

struct PlacesListView: View {
    
    @Environment(\.networkAPI) var network
    
    @StateObject private var placesRepo: PlacesRepository = .init()
   
    
    @State var showAddNewPlace: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(placesRepo.placeIndexes, id: \.self) { placeId in
                    PlaceListCellView(placeId: placeId)
                }
            }
            .onAppear {
                placesRepo.startSubscription(path: network.getPlacesPath())
            }
            .onDisappear{
                placesRepo.stopSubscription()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .refreshable {
            showAddNewPlace.toggle()
        }
        .toolbar {
            Button {
                showAddNewPlace.toggle()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .sheet(isPresented: $showAddNewPlace) {
            NewPlaceView()
                .presentationDetents([.large])
        }
    }
}


#Preview {
    PlacesListView()
}
