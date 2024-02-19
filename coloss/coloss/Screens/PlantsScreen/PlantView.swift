//
//  PlantView.swift
//  coloss
//
//  Created by Dev on 13.02.24.
//

import SwiftUI

struct PlantView: View {
    @Environment(\.networkAPI) var network
    @Environment(\.storageAPI) var storage
    
    @State var plant: Plant?
    let plantId: String
    
    var body: some View {
        if let plant = plant {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        
                        HStack(alignment: .center) {
                            Image(uiImage: .imagePlaceholder)
                                .load(id: plant.imageId, provider: storage)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .ignoresSafeArea(edges: .top)
                            
                            Text(plant.title)
                                .font(.title)
                                .padding()
                        }
                        .padding(.horizontal)
                        
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(.red)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                Text("Loading...")
                    .task {
                        plant = try? await network.getPlant(by: plantId)
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    PlantView(plantId: "")
}
