import SwiftUI
import FirebaseCore
import FirebaseAuthUI
import GoogleSignIn

//import FirebaseFirestore
//import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    let authUI = FUIAuth.defaultAuthUI()
    return true
  }
}

@main
struct ReelKeeperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthenticationViewModel()
    let persistenceController = PersistenceController.shared



    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)

        }
    }
}
