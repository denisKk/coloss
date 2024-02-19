//
//  NewPlaceView.swift
//  coloss
//
//  Created by Dev on 14.02.24.
//

import SwiftUI
import PhotosUI

struct NewPlaceView: View {
    
    @Environment(\.networkAPI) var network
    @Environment(\.storageAPI) var storage
    @Environment(\.dismiss) var dismiss
    
    @State var place: Place = Place(title: "")
    @State var placeImage: UIImage? = nil
    @State var saveProcess: Bool = false
    @State var showCameraPicker = false
    
    @State private var selectedItem: PhotosPickerItem?
    
    @FocusState private var focusedField: Field?
    
    private enum Field: Int {
        case name, description
    }
    
    private var isFormValid: Bool {
        guard place.title.isEmpty
        else { return true }
        return false
    }
    
    var body: some View {
        Background {
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("Create new place")
                        .font(.largeTitle)
                    
                    Text("Place name")
                        .padding(.top, 8)
                    TextField("type name...", text: $place.title)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .name)
                        .disabled(saveProcess)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button {
                                    focusedField = nil
                                } label: {
                                    Image(systemName: "keyboard.chevron.compact.down")
                                }
                            }
                        }
                    
//                    Text("Place description")
//                        .padding(.top, 8)
//                    TextField("type name...", text: $description, axis: .vertical)
//                        .lineLimit(3, reservesSpace: true)
//                        .textFieldStyle(.roundedBorder)
//                        .focused($focusedField, equals: .description)
//                        .disabled(saveProcess)
//                    
                    image
                        .disabled(saveProcess)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .sheet(isPresented: $showCameraPicker) {
            CameraPicker(sourceType: .camera, showImagePicker: $showCameraPicker, image: $placeImage)
        }
    }
    
    
    @ViewBuilder
    var image: some View {
        VStack {
            if let imageId = placeImage {
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
                                placeImage = UIImage(data: data)
                            }
                        }
                        print("Failed to load the image")
                    }
                })
                
                
                
                Spacer()
                
                
                if placeImage.isNotNil{
                    Button  {
                        withAnimation {
                            placeImage = nil
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
                      await saveNewPlace()
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
        .padding(.top, 16)
    }
    
    func hideKeyboard() {
        focusedField = nil
    }
    
    @Sendable
    func saveNewPlace() async{
        let imageId = placeImage.isNil ? nil : String.generateRandom(size: 9)
        
        place.imageId = imageId
        
        do {
            saveProcess = true
            if let imageId = imageId, let image = placeImage
            {
                try await storage.saveUserPhoto(image: image, imageId: imageId)
            }
            try await network.addPlace(place)
            saveProcess = false
            dismiss()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

#Preview {
    NewPlaceView()
}
