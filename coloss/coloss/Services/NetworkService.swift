//
//  NetworkService.swift
//  coloss
//
//  Created by Dev on 10.02.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

protocol NetworkService {
    func getPlantsPath(with placeId: String) -> String
    func getPlacesPath() -> String
    func getPlace(by id: String) async -> Place?
    func getPlant(by id: String) async throws -> Plant?
    func deletePlace(by index: String) async throws
    func addPlace(_ place: Place) async throws
    func addPlant(_ plant: Plant, placeId: String, groupId: String?) async throws
    func deletePlant(by index: String, placeId: String, groupId: String?) async throws
    func getAllCategories() async -> [Category]
    func addCategories(names: [String]) async throws
}

struct FirebaseFirestore: NetworkService {
    
    let userId: String
    
    private let db = Firestore.firestore()
    private var userCollectionRef: CollectionReference { db.collection("users") }
    private var userDocumentRef: DocumentReference { userCollectionRef.document(userId) }
    private var userPlacesCollectionRef: CollectionReference { userDocumentRef.collection("places") }
    private var userPlantsCollectionRef: CollectionReference { userDocumentRef.collection("plants") }
    private var userPlacesSortDocumentRef: DocumentReference { userDocumentRef.collection("placeSort").document("sortIndexes") }
    private var categoriesCollectionRef: CollectionReference { db.collection("categories") }
    
    func getPlantsPath(with placeId: String) -> String {
        return "users/\(userId)/places/\(placeId)/plantSort/sortIndexes"
    }
    
    func getPlacesPath() -> String {
        return userPlacesSortDocumentRef.path
    }
    
    func getPlace(by id: String) async -> Place? {
        do {
            return try await userPlacesCollectionRef.document(id).getDocument(as: Place.self)
        } catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func getPlant(by id: String) async throws -> Plant? {
        return try await userPlantsCollectionRef.document(id).getDocument(as: Plant.self)
    }
    
    func deletePlace(by index: String) async throws {
        
        let batch = db.batch()
        
        let path = getPlantsPath(with: index)
        let refSort = db.document(path)
        let placeRef = userPlacesCollectionRef.document(index)
        let placeSortRef = userPlacesSortDocumentRef
        
        if let array = try? await refSort.getDocument(as: SortIndexes.self),
           let positions = array.positions
        {
            for plantId in positions {
                let ref = userPlantsCollectionRef.document(plantId)
                batch.deleteDocument(ref)
            }
        }
        
        batch.deleteDocument(refSort)
        batch.deleteDocument(placeRef)
        batch.setData(["positions" : FieldValue.arrayRemove([index])], forDocument: placeSortRef, merge: true)
        
        try await batch.commit()
    }
    
    func addPlace(_ place: Place) async throws {
        
        let batch = db.batch()
        
        let placeRef = userPlacesCollectionRef.document()
        let placeSortRef = userPlacesSortDocumentRef
        
        try batch.setData(from: place, forDocument: placeRef)
        batch.setData(["positions" : FieldValue.arrayUnion([placeRef.documentID])], forDocument: placeSortRef, merge: true)
        
        try await batch.commit()
    }
    
    
    func addPlant(_ plant: Plant, placeId: String, groupId: String? = nil) async throws {
        
        let batch = db.batch()
        
        let plantRef = userPlantsCollectionRef.document()
        
        let plantSortRef: DocumentReference = switch groupId {
        case .some(let group):
            userPlacesCollectionRef.document(group).collection("groupSort").document("sortIndexes")
        case .none:
            userPlacesCollectionRef.document(placeId).collection("plantSort").document("sortIndexes")
        }
        
        try batch.setData(from: plant, forDocument: plantRef)
        batch.setData(["positions" : FieldValue.arrayUnion([plantRef.documentID])], forDocument: plantSortRef, merge: true)
        
        try await batch.commit()
    }
    
    func deletePlant(by index: String, placeId: String, groupId: String? = nil) async throws {
        
        let batch = db.batch()
        
        let plantRef = userPlantsCollectionRef.document(index)
        
        let plantSortRef: DocumentReference = switch groupId {
        case .some(let group):
            userPlacesCollectionRef.document(group).collection("groupSort").document("sortIndexes")
        case .none:
            userPlacesCollectionRef.document(placeId).collection("plantSort").document("sortIndexes")
        }
        
        batch.deleteDocument(plantRef)
        batch.setData(["positions" : FieldValue.arrayRemove([index])], forDocument: plantSortRef, merge: true)
        
        try await batch.commit()
    }

    func getAllCategories() async -> [Category] {
        guard let snapshot = try? await categoriesCollectionRef.getDocuments() else {
            return []
        }
        return FirestoreDecoder.decodeColl([Category].self)(snapshot) ?? []
    }
    
    func addCategories(names: [String]) async throws {
        let batch = db.batch()
        
        try names.forEach { name in
            
            let doc = categoriesCollectionRef.document()
            try batch.setData(from: Category(title: name), forDocument: doc)
        }
        
        try await batch.commit()
        
    }
}

struct mocNetworkAPI: NetworkService {
    func getPlantsPath(with placeId: String) -> String {
        return ""
    }
    
    func getPlacesPath() -> String {
        return ""
    }
    
    func getPlace(by id: String) async -> Place? {
        return Place.mocPlaces.first
    }
    
    func getPlant(by id: String) async throws -> Plant? {
        return Plant.init(title: "Test Plant")
    }
    
    func deletePlace(by index: String) async throws {}
    
    func addPlace(_ place: Place) async throws {}
    
    func addPlant(_ plant: Plant, placeId: String, groupId: String?) async throws {}
    
    func deletePlant(by index: String, placeId: String, groupId: String?) async throws {}
    
    func getAllCategories() async -> [Category] { [] }
    
    func addCategories(names: [String]) async throws {}
}
