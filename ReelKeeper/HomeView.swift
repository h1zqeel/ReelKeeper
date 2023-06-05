import SwiftUI
import GoogleSignIn
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import GoogleSignIn
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    struct MenuItem: Hashable {
        var name: String
    }
    let fre = FireStoreHelper()
    private let user = Auth.auth().currentUser
    @State var showAccountLinkage = false
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
            HStack{
                SFButton(
                    disableOn: .constant(false),
                    customAction: .constant {
                        showAccountLinkage.toggle()
                    },
                    SFImage: .constant("link.badge.plus")
                )
                SFButton(
                    disableOn: .constant(false),
                    customAction: .constant {
                        viewModel.signOut()
                    },
                    SFImage: .constant("rectangle.portrait.and.arrow.right")
                )
            }
        }
        .sheet(isPresented: $showAccountLinkage) {
            AccuntLinkageModal()
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
