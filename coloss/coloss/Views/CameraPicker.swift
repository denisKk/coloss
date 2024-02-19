//
//  ImagePicker.swift
//  kosynka online
//
//  Created by Dev on 13.02.23.
//  Copyright © 2023 kulakov. All rights reserved.
//

import PhotosUI
import SwiftUI

struct CameraPicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.editedImage] as? UIImage {
    
                let scaledImage = image.scalePreservingAspectRatio()
                self.parent.image =  UIImage(data: scaledImage.jpegData(compressionQuality: 0.2)!)
            }
            parent.showImagePicker = false
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    var sourceType: UIImagePickerController.SourceType
    @Binding var showImagePicker: Bool
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
    
     //   picker.mediaTypes = ["public.image", ""]
       // picker.videoQuality = .typeHigh
     //   picker.videoMaximumDuration = TimeInterval(30)
       // picker.modalPresentationStyle = .popover
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPicker>) {
        uiViewController.popoverPresentationController?.sourceRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0))
    }
}
