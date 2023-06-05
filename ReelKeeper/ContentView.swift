
import SwiftUI
import CoreData
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        
        switch viewModel.state {
              case .signedIn: HomeView()
              case .signedOut: LoginView()
            }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct MenuItem: Hashable {
    let name: String
}
