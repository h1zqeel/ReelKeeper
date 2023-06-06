import Foundation

class Movie : ObservableObject, Hashable {
    @Published var id: String?
    @Published var title: String
    @Published var date: Date
    @Published var rating: Int
    @Published var watched: Bool

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    init(id: String, title: String, date: Date, rating: Int, watched: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.rating = rating
        self.watched = watched
      }
}
