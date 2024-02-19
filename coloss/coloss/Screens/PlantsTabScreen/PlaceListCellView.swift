//
//  PlaceListCellView.swift
//  coloss
//
//  Created by Dev on 12.02.24.
//

import SwiftUI

struct PlaceListCellView: View {
    
    @State var place: Place?
    @Environment(\.networkAPI) var network
    @Environment(\.storageAPI) var storage
    @EnvironmentObject var router: Router
    
    @State var showActionDialog: Bool = false
    
    let placeId: String
    
    var body: some View {
        
        VStack {
            title
            image
                .clipped()
                .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .stroke()
                .fill(.textfieldStroke)
        }
        .padding(24)
        .task {
            if let place = await network.getPlace(by: placeId) {
                self.place = place
            }
        }
        .onTapGesture {
            router.plantRoutes.append(.place(placeId))
        }
        .onLongPressGesture(perform: {
            showActionDialog = true
        })
        .actionSheet(isPresented: $showActionDialog) {
            ActionSheet(
                title: Text("Delete a Place? \(place?.title ?? "")"),
                buttons: [
                    
                    .destructive(Text("Aplly")) {
                        Task.detached(priority: .background) {
                            try? await network.deletePlace(by: placeId)
                        }
                        
                        guard let imageId = place?.imageId else {return}
                        
                        Task.detached(priority: .background) {
                            try? await storage.deletePhoto(by: imageId)
                        }
                    },
                        .cancel(Text("Cancel"))
                ]
            )
        }
        
    }
    
    @ViewBuilder
    var title: some View {
        Text(place?.title ?? "")
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    var description: some View {
        if let description = place?.description {
            Text(description)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var image: some View {
        switch place?.imageId {
        case .some(let id):
            Image(uiImage: UIImage.imagePlaceholder)
                .load(id: id, provider: storage)
                .frame(maxWidth: .infinity, maxHeight: 200)
        case .none:
            Image(uiImage: UIImage.imagePlaceholder)                       
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
}

#Preview {
    PlaceListCellView(place: .mocPlaces.first, placeId: "someId")
}
