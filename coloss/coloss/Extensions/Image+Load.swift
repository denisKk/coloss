//
//  UIImage+Static.swift
//  coloss
//
//  Created by Dev on 16.02.24.
//

import UIKit
import SwiftUI

extension Image {
    
    @ViewBuilder
    func load(id: String?, provider: StorageService) -> some View {
        
        if let id = id {
            self
                .resizable()
                .aspectRatio(contentMode: .fill)
                .modifier(LoadImageModifier(imageId: id, provider: provider))
        } else {
            self
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct LoadImageModifier: ViewModifier {
    
    let imageId: String
    let provider: StorageService
    @State var loadingImage: UIImage?
    @State var isLoading: Bool = false
    
    func body(content: Content) -> some View {
        
        ZStack {
            if let image = loadingImage {
                content
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
            } else {
                content
                    .task(loadImage)
                    .overlay {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
            }
        }
        .animation(.bouncy, value: loadingImage)
        
    }
    
    @Sendable
    func loadImage() async {
        isLoading = true
        if let image = await provider.loadPhoto(by: imageId) {
//            loadingImage = await image.byPreparingThumbnail(ofSize: CGSize(width: 600, height: 400))
            loadingImage = image
        }
        isLoading = false
    }
    
}
