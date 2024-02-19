//
//  FirestoreSubscription.swift
//  coloss
//
//  Created by Dev on 11.02.24.
//



import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreSubscription {
    
    static func subscribeCollection<T>(id: AnyHashable, ref: CollectionReference) -> AnyPublisher<T, Never> {
        let subject = PassthroughSubject<T, Never>()
    
        let listener = ref.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot as? T {
                subject.send(snapshot)
            }
        }
        
        listeners[id] = Listener(listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
    static func subscribeCollection<T>(id: AnyHashable, path: String) -> AnyPublisher<T, Never> {
        let subject = PassthroughSubject<T, Never>()
    
        let ref = Firestore.firestore().collection(path)
        let listener = ref.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot as? T {
                subject.send(snapshot)
            }
        }
        
        listeners[id] = Listener(listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
    static func subscribeDocument<T>(id: AnyHashable, ref: DocumentReference) -> AnyPublisher<T, Never> {
        let subject = PassthroughSubject<T, Never>()
        
        let listener = ref.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot as? T {
                subject.send(snapshot)
            }
        }
        
        listeners[id] = Listener(listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
    static func subscribeDocument<T>(id: AnyHashable, path: String) -> AnyPublisher<T, Never> {
        let subject = PassthroughSubject<T, Never>()
        
        let ref = Firestore.firestore().document(path)
        let listener = ref.addSnapshotListener { snapshot, _ in
            if let snapshot = snapshot as? T {
                subject.send(snapshot)
            }
        }
        
        listeners[id] = Listener(listener: listener, subject: subject)
        
        return subject.eraseToAnyPublisher()
    }
    
    static func cancel(id: AnyHashable) {
        
        if let listener = listeners[id],
           let subject = listener.subject as? PassthroughSubject<Any, Never>
        {
            subject.send(completion: .finished)
        }
        listeners[id]?.listener.remove()
        listeners[id] = nil
        
    }
}

private struct Listener{
    let listener: ListenerRegistration
    let subject: Any
}

private var listeners: [AnyHashable: Listener] = [:]
