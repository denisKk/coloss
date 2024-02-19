//
//  NewPlantView.swift
//  coloss
//
//  Created by Dev on 17.02.24.
//

import SwiftUI
import PhotosUI

struct NewPlantView: View {
    
    @Environment(\.networkAPI) var network
    @Environment(\.storageAPI) var storage
    @Environment(\.dismiss) var dismiss
    
    var placeId: String

    @State var coverImage: UIImage? = nil
    @State var newPlant: Plant = .init(title: "")
    @State var saveProcess: Bool = false
    @State var allCategories: [Category] = .init()
    @State var selectedCategory: Category?
    @State var showSelectedCategoryView = false
    @State var showPlantClassifierView = false
    @State var showCameraPicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    
    @FocusState private var focusedField: Field?
    
    
    private enum Field: Int {
        case name, description
    }
    
    private var isFormValid: Bool {
        guard newPlant.title.isEmpty else { return true }
        return false
    }
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("Add new plant")
                        .font(.largeTitle)
                        .task {
                            allCategories = await network.getAllCategories()
                        }
                    
                    Text("Plant name")
                        .padding(.top, 8)
                    
                    TextField("type name...", text: $newPlant.title)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .name)
                        .disabled(saveProcess)
                        .onChange(of: selectedCategory, perform: { newValue in
                            if newPlant.title.isEmpty,
                                let title = newValue?.title
                            {
                                newPlant.title = title
                            }
                        })
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Category")
                                .padding(.top, 8)
                            
                            Button(selectedCategory?.title ?? "select...") {
                                showSelectedCategoryView = true
                            }
                        }
                        
                        
                        VStack {
                            Button {
                                showPlantClassifierView = true
                            } label: {
                                Image(systemName: "camera.metering.unknown")
                            }
                        }
                        .font(.largeTitle)
                        .foregroundStyle(.green.gradient)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    }

                    Text("Cover photo")
                        .padding(.top, 8)
                    
                    image
                        .disabled(saveProcess)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            }
            .sheet(isPresented: $showSelectedCategoryView) {
                SelectCategoryView(selectedCategory: $selectedCategory, allCategories: allCategories)
            }
            .sheet(isPresented: $showPlantClassifierView) {
                PlantsClassifierView(selectedCategory: $selectedCategory, coverImage: $coverImage, categories: allCategories)
            }
            .sheet(isPresented: $showCameraPicker) {
                CameraPicker(sourceType: .camera, showImagePicker: $showCameraPicker, image: $coverImage)
            }
    }
    
    
    @ViewBuilder
    var image: some View {
        VStack {
            if let imageId = coverImage {
                Image(uiImage: imageId)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .allowsHitTesting(false)
            }
            else {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(style: .init(dash: [8]))
                    .fill(.gray)
                    .frame(height: 200)
                    .background{
                        VStack {
                            Image(systemName: "circle.slash")
                            Text("no image")
                        }
                        .font(.headline)
                        .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 1)
            }
            
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
                                coverImage = UIImage(data: data)
                            }
                        }
                        print("Failed to load the image")
                    }
                })
                
                
                
                Spacer()
                
                
                if coverImage.isNotNil{
                    Button  {
                        withAnimation {
                            coverImage = nil
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
            
            
            HStack {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .padding(.trailing)
                .disabled(saveProcess)
                
                
                Button() {
                    Task {
                      await saveNewPlant()
                    }
                } label: {
                    HStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .opacity(saveProcess ? 1 : 0)
                        
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
                .disabled(!isFormValid)
                .disabled(saveProcess)
            }
            .padding(.vertical, 24)
            
        }
       // .padding(.top,2)
    }
    
    func hideKeyboard() {
        focusedField = nil
    }
    
    @Sendable
    func saveNewPlant() async{
        let imageId = coverImage.isNil ? nil : String.generateRandom(size: 9)
        
        newPlant.imageId = imageId
        
        
        
        do {
            saveProcess = true
            if let imageId = imageId, let image = coverImage
            {
                try await storage.saveUserPhoto(image: image, imageId: imageId)
            }
            try await network.addPlant(newPlant, placeId: placeId, groupId: nil)
            saveProcess = false
            dismiss()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

#Preview {
    NewPlantView(placeId: "dsfs")
}
