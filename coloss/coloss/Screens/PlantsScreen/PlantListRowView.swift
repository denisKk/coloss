//
//  PlantListRowView.swift
//  coloss
//
//  Created by Dev on 13.02.24.
//

import SwiftUI

struct PlantListRowView: View {
    
    @Environment(\.networkAPI) var network
    @Environment(\.storageAPI) var storage
    
    @State var plant: Plant?
    
    let plantId: String
    
    
    var body: some View {
        HStack {
            
            Image(uiImage: UIImage.imagePlaceholder)
                .load(id: plant?.imageId, provider: storage)
                .frame(width: 30, height: 30)
                .clipped()
                .contentShape(Rectangle())
                
            
            Text("\(plant?.title ?? "no title")")
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.1).gradient)
        }
        .padding(.horizontal)
        
        .task {
            plant = try? await network.getPlant(by: plantId)
        }
    }
}

#Preview {
    PlantListRowView(plantId: "xvs")
}
