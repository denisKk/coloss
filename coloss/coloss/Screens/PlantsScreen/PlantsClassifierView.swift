//
//  PlantsClassifierView.swift
//  coloss
//
//  Created by Dev on 18.02.24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct PlantsClassifierView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var image: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State var results: [(Category, Double)] = .init()
    @Binding var selectedCategory: Category?
    @Binding var coverImage: UIImage?
    @State var showCameraPicker = false
   
    let classifier = PlantsClassifier()
    let categories: [Category]
    
    var isValidForm: Bool {
        image.isNil
    }
    
    var body: some View {
        VStack {
            
           container
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                       .stroke(style: .init(lineWidth: 2, dash: [5]))
                }
                .frame(height: 500)
            
            HStack {
                Button {
                    showCameraPicker = true
                } label: {
                    Image(systemName: "camera")
                        .frame(minHeight: 20)
                }
                .buttonStyle(.bordered)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    
                    Button {
                        
                    } label:
                    {
                        Image(systemName: "photo.stack")
                            .frame(height: 20)
                    }
                    .buttonStyle(.bordered)
                    .overlay {
                        Color.white
                            .opacity(0.01)
                    }
                }
                .onChange(of: selectedItem, perform: { _ in
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            withAnimation {
                                image = UIImage(data: data)
                            }
                        }
                        print("Failed to load the image")
                    }
                })
                
                
                Spacer()
                
                
                if image.isNotNil{
                    Button  {
                        withAnimation {
                            image = nil
                        }
                    } label: {
                        
                        Image(systemName: "trash")
                            .frame(height: 20)
                    }
                    .buttonStyle(.bordered)
                    .tint(.redGradientEndPoint)
                }
                else {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            
            Button {
                start()
            } label: {
                Text("Start classifier")
                    .padding(.horizontal, 24)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isValidForm)
            
            Spacer()
            
            if !results.isEmpty {
                resultsView
            }

        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(sourceType: .camera, showImagePicker: $showCameraPicker, image: $image)
        }
        .onAppear{
            if let cover = coverImage {
                image = coverImage
            }
        }
    }
    
    @ViewBuilder
    var container: some View {
        switch image {
        case .none:
            RoundedRectangle(cornerRadius: 5)
                .fill(.gray.gradient)
        case .some(let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
    }
    
    private func start() {
        guard let image = image else { return }
        
        try? classifier.makePredictions(for: image, completionHandler: predictionHandler)
    }
    
    private func predictionHandler(_ predictions: [PlantsClassifier.Prediction]?) {
        results.removeAll()
        guard let predictionsArray = predictions?.prefix(2) else { return }
        
        predictionsArray.forEach { classifier in
            if let category = categories.first(where: { itemCategory in
                itemCategory.title == classifier.classification}),
               let number = Double(classifier.confidencePercentage),
               number > 0.001
            {
                results.append((category, number))
            }
        }
    }
    
    @ViewBuilder
    var resultsView: some View {
        HStack(alignment: .top) {
            Text("It's maybe:")
                .font(.title3)
            VStack(alignment: .leading) {
                ForEach(results, id: \.0.title) { item in
                    HStack {
                        Button {
                            selectedCategory = item.0
                            
                            if coverImage == nil {
                                coverImage = image
                            }
                            
                            dismiss()
                        } label: {
                            HStack {
                                Text(item.0.title)
                                Text(String(format: " %.1f%%", item.1 * 100))
                            }
                        }
                        .buttonStyle(.bordered)
                       
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    PlantsClassifierView(selectedCategory: .constant(nil), coverImage: .constant(nil), categories: [])
}
