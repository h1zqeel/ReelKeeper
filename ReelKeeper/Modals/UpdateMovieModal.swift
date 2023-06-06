import SwiftUI
import FirebaseFirestore


struct UpdateMovieModal: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var movie : Movie
    var fireStoreHelper = FireStoreHelper()
    let db = Firestore.firestore()
    func validateData() -> Bool{
        if(movie.title.isEmpty) {
            return true
        }
        if(movie.watched == true){
            if(movie.rating == 0){
                return true
            }
        }
        return false
    }
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()

    }
    func updateMovie(){
        if(movie.title.isEmpty){
            return
        }
        fireStoreHelper.updateDataInCollection(
            id: movie.id!,
            name: "movies",
            data: [
                "title":  movie.title,
                "watched": movie.watched,
                "date": movie.date,
                "rating": movie.rating
            ]
        )
        dismissModal()
    }
    var body: some View {
        Form {
            Section{
                TextField("Title", text: $movie.title)
                Toggle("Have You Watched This Movie", isOn: $movie.watched)
                if(movie.watched == true) {
                    DatePicker(
                        "Watch Date",
                        selection: $movie.date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    StarRating(rating: $movie.rating, label: .constant("Rating"))

                }
                
            } header: {
                SaneHeaderText(header: .constant("Movie Details"))
            }
            Button(action: updateMovie) {
                Text("Update")
            }
            .disabled(validateData())
        }
    }
}
