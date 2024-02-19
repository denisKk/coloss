//
//  colossApp.swift
//  coloss
//
//  Created by Dev on 6.02.24.
//
import SwiftUI
import Firebase
import FirebaseAppCheck

@main
struct ColossApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var selectionTab: AppScreen = .main
  
    var body: some Scene {
        WindowGroup {
            LoadingScreen()
                .environmentObject(UserModel(authService: AuthServiceImpl(), secureService: Keychain()))
                .environmentObject(Router())
        }
    }
    
    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication,
                         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            let providerFactory = ColosAppCheckProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
            
            FirebaseApp.configure()
            return true
        }
    }
    
    
}

class ColosAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
//    #if DEBUG
//      return AppCheckDebugProvider(app: app)
//    #endif
    return AppAttestProvider(app: app)
  }
}
