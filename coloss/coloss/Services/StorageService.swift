//
//  StorageService.swift
//  kosynka online
//
//  Created by Dev on 13.02.23.
//  Copyright © 2023 kulakov. All rights reserved.
//
import FirebaseStorage
import FirebaseStorageCombineSwift
import UIKit


extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

let photoCache = NSCache<NSString, UIImage>()

protocol StorageService {
    func saveUserPhoto(image: UIImage, imageId: String) async throws
    func deletePhoto(by imageId: String) async throws
    func loadPhoto(by imageId: String) async -> UIImage?
}

struct FirebaseStorage: StorageService {
    
    let userId: String
    
    private let imageFolder = "userPhotos/"
    private let server = "kolos-7ab2b.appspot.com"
    private let compressionQuality = 0.2
    
    private var stroageURL: String {
        "gs://" + server + "/"
    }
    
    private func saveToCache(image: UIImage, id: NSString) async {
        photoCache.setObject(image, forKey: id)
    }
    
    private func removeFromCache(id: NSString) async {
        photoCache.removeObject(forKey: id)
    }

    func saveUserPhoto(image: UIImage, imageId: String) async throws {
        
        let resizedImage = image.aspectFittedToHeight(300)
        let data = image.jpegData(compressionQuality: compressionQuality)! as Data
        let filePath = imageFolder + userId + "/" + imageId
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        do {
            let _ = try await Storage.storage().reference(forURL:stroageURL).child(filePath).putDataAsync(data, metadata: metaData)
            Task.detached(priority: .background) {
                await saveToCache(image: image, id: imageId as NSString)
            }
        } catch {
            throw error
        }
    }
    
    func deletePhoto(by imageId: String) async throws {

        let filePath = imageFolder + userId + "/" + imageId
        
        do {
            try await Storage.storage().reference(forURL:stroageURL).child(filePath).delete()
            Task.detached(priority: .background) {
                await removeFromCache(id: imageId as NSString)
            }
        } catch {
            throw error
        }
    }
    
    
    func loadPhoto(by imageId: String) async -> UIImage? {
        if let image = photoCache.object(forKey: imageId as NSString) {
            return image
        }
        
        let filePath = imageFolder + userId + "/" + imageId
        print(filePath)
        
        guard let data = try? await Storage.storage().reference(forURL:stroageURL).child(filePath)
            .data(maxSize: 1 * 1024 * 1024) else {
            return nil
        }
        guard let image = UIImage(data: data) else { return nil }

        Task.detached(priority: .background){
            await saveToCache(image: image, id: imageId as NSString)
        }
        return image

    }
}

struct MocStorageService: StorageService {
    func saveUserPhoto(image: UIImage, imageId: String) async throws {}
    func deletePhoto(by imageId: String) async throws {}
    func loadPhoto(by imageId: String) async -> UIImage? { return
        UIImage.tulip
    }
}
