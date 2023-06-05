import Firebase
import GoogleSignIn
import FirebaseFirestore

struct Movie : Hashable {
    var id: String?
    var title: String?
    var date: Date?
    var rating: Int?
    var watched: Bool?
}

class MoviesViewModel: ObservableObject {
    @Published var movies = [Movie]()

    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    func fetchMoviesForUser()   {
        db.collection("users").document(currentUser?.email ?? "nil").collection("movies")
            .order(by: "watched", descending: false)
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("no docs")
                    return
                }
                self.movies = documents.map { queryDocumentSnapshot -> Movie in
                    let data = queryDocumentSnapshot.data()
                    let id = queryDocumentSnapshot.documentID
                    let title = data["title"] as? String ?? ""
                    let date = data["date"] as? Timestamp
                    let watched = data["watched"] as? Bool ?? false
                    let rating = data["rating"] as? Int ?? 0
                    return Movie(id: id, title: title, date: date?.dateValue(), rating: rating, watched: watched)
                }
            }
    }
    
    func deleteMovie(id: String){
        db.collection("users").document(currentUser?.email ?? "nil").collection("movies").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}
