import SwiftUI

struct MovieListItem: View {
    @Binding var movie: Movie
    @StateObject var moviesViewModel = MoviesViewModel()
    @State private var confirmDelete: Bool = false
    var watchedColor = Color.gray
    var nilWatchedColor = Color.white
    @State private var updateMovie = false
    var body: some View {
        VStack{
            HStack {
                Text(movie.title)
                Spacer()
                Image(systemName: movie.watched ? "eye.circle.fill" : "eye.slash.circle.fill")
                    .resizable()
                    .frame(width: 25.0, height: 25.0)
                    .foregroundColor(movie.watched ? watchedColor : nilWatchedColor)
            }
            .padding(10)
            if(movie.watched == true){
                HStack{
                    StarRating(rating: .constant(movie.rating), label: .constant(""))
                    Spacer()
                    Text(movie.date, style: .date)
                }
                .padding(10)
            }
        }
        .swipeActions(edge: .leading) {
            Button (role: .destructive) {
                moviesViewModel.deleteMovie(id: movie.id ?? "")
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
            .tint(.red)
        }
        .swipeActions(edge: .trailing) {
            Button {
                updateMovie = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .sheet (isPresented: $updateMovie) {
            UpdateMovieModal(movie: movie)
        }
       
    }
}

