//
//  UIImage+Scale.swift
//  coloss
//
//  Created by Dev on 19.02.24.
//

import Foundation
import UIKit

extension UIImage {
    func scalePreservingAspectRatio() -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        
        let sizeMin = min(size.width, size.height)
//
//        let widthRatio = targetSize.width / sizeMin
//        let heightRatio = targetSize.height / sizeMin
//
//        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: sizeMin,
            height: sizeMin
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        let data = scaledImage.jpegData(compressionQuality: 0.3)
        
        return UIImage(data: data!)!
    }
}
