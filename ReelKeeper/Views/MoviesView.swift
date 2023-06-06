import SwiftUI
import FirebaseFirestore

struct MoviesView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @StateObject var moviesViewModel = MoviesViewModel()
    @State private var searchText = ""

    @State var showingSheet = false
    let dateFormatter = DateFormatter()
    @State private var confirmDelete: Bool = false
    @State private var movieToDelete: Movie? = nil
    var movieSearchResults: [Movie] {
        if searchText.isEmpty {
            return moviesViewModel.movies
        } else {
            return moviesViewModel.movies.filter { $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(movieSearchResults, id: \.self) { movie in
                    MovieListItem(movie: .constant(movie))

                }
            }
        }
        .navigationTitle("Movies")
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {
                    print("button pressed")
                    showingSheet.toggle()
                    
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear() {
            self.moviesViewModel.fetchMoviesForUser()
        }
        .sheet(isPresented: $showingSheet) {
            CreateMovieModal()
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}

