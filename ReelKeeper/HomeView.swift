import SwiftUI
import GoogleSignIn
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    struct MenuItem: Hashable {
        var name: String
    }
    let fre = FireStoreHelper()
    private let user = Auth.auth().currentUser
    let menuItems : [MenuItem] = [.init(name: "Movies")]
    var body: some View {
        NavigationStack {
            List {
                    ForEach(menuItems, id: \.self) { item in
                        NavigationLink(value: item){
                            Text(item.name)
                        }
                }
            }
            .navigationTitle("ReelKeeper")
            
            .navigationDestination(for: MenuItem.self) {
                item in
                MoviesView()
            }
            Button(action: viewModel.signOut) {
                Text("Sign out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.gray))
                    .cornerRadius(12)
                    .padding()
            }
        }
    }
}

/// A generic view that shows images from the network.
struct NetworkImage: View {
    let url: URL?
    
    var body: some View {
        if let url = url,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
