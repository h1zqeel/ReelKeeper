import SwiftUI
import FirebaseFirestore


struct UpdateMovieModal: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var id: String
    @State var title: String
    @State var watched: Bool
    @State var rating: Int
    @State var date: Date
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
    func updateMovie(){
        if(title.isEmpty){
            return
        }
        fireStoreHelper.updateDataInCollection(
            id: id,
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
                        //                         in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    StarRating(rating: $rating, label: .constant("Rating"))

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
