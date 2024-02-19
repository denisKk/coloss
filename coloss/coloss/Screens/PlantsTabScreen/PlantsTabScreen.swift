//
//  PlantsView.swift
//  coloss
//
//  Created by Dev on 10.02.24.
//

import SwiftUI

struct PlantsTabScreen: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            NavigationStack(path: $router.plantRoutes) {
                PlacesListView()
                    .navigationDestination(for: PlantRoute.self) { route in
                        switch route {
                        case .place(let id):
                            PlaceView(placeId: id)
                        case .group(let id):
                            Text(id)
                        case .plant(let id):
                            PlantView(plantId: id)
                        }
                    }
                    .navigationTitle("Places")
            }
        }
    }
}

#Preview {
    PlantsTabScreen()
        .environmentObject(Router())
}
