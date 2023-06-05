import SwiftUI
import FirebaseFirestore


struct CreateMovieModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = "";
    @State private var watched = false;
    @State private var rating = 0;
    @State private var date = Date()
    @State private var movieToEdit : Movie?
    var fireStoreHelper = FireStoreHelper()
    let db = Firestore.firestore()
    func validateData() -> Bool{
        if(title.isEmpty) {
            return true
        }
        if(watched == true){
            if(rating == 0){
                return true
            }
        }
        return false
    }
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()

    }
    func addMovie(){
        if(title.isEmpty){
            return
        }
        fireStoreHelper.addDataInCollection(
            name: "movies",
            data: [
                "title": title,
                "watched": watched,
                "date": date,
                "rating": rating
            ]
        )
        dismissModal()
    }
    var body: some View {
        Form {
            Section{
                TextField("Title", text: $title)
                Toggle("Have You Watched This Movie", isOn: $watched)
                if(watched == true) {
                    DatePicker(
                        "Watch Date",
                        selection: $date,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    StarRating(rating: $rating, label: .constant("Rating"))

                }
                
            } header: {
                SaneHeaderText(header: .constant("Movie Details"))
            }
            Button(action: addMovie) {
                Text("Save")
            }
            .disabled(validateData())
        }
    }
}
struct CreateMovieModal_Previews: PreviewProvider {
    static var previews: some View {
        CreateMovieModal()
    }
}
